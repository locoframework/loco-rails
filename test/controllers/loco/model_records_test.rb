# frozen_string_literal: true

require 'test_helper'

module Loco
  class ModelRecordsTest < ActionDispatch::IntegrationTest
    test 'a seeded page declares its position on the notification clock' do
      get '/'
      assert_response :success

      script = response.parsed_body.at_css("script[data-model='Article']")
      assert_not_nil script

      as_of = Time.zone.parse(script['data-as-of'])
      assert_not_nil as_of
      assert_in_delta Notification::Fetch::OVERLAP.ago, as_of, 2
      assert_equal Article.published.count, JSON.parse(script.text).size
    end

    test 'as_of precedes a notification emitted while the page renders' do
      get '/'
      as_of = Time.zone.parse(response.parsed_body
                                .at_css("script[data-model='Article']")['data-as-of'])

      Loco.emit({ event: :published }, subject: articles(:one))
      synced_at = Notification::Presenter.(Notification.order(:created_at).last)[:loco][:synced_at]

      assert Time.zone.parse(synced_at) >= as_of,
             'a notification created after the render must replay against the snapshot'
    end

    test 'JSON is escaped so it cannot break out of the script tag' do
      article = articles(:one)
      article.update! title: '</script><script>alert(1)</script>'

      get '/'
      assert_not_includes response.body, '</script><script>alert(1)'
      script = response.parsed_body.at_css("script[data-model='Article']")
      assert_includes JSON.parse(script.text).pluck('title'), article.title
    end
  end
end
