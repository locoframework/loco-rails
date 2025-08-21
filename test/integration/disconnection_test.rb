# frozen_string_literal: true

require 'test_helper'

class DisconnectionTest < IT
  include CapybaraOffline
  include CommonHelpers

  def setup
    super
    visit '/'
    go_disconnected
  end

  test 'fetches missed notifications' do
    create_comment_for_article :one
    create_comment_for_article :one, author: 'Jason', text: 'Very interesting...'
    go_connected
    within "article#article_#{articles(:one).id}" do
      assert page.has_content? '2 comments'
    end
  end
end
