# frozen_string_literal: true

require 'test_helper'

class User
  class ArticlesCreatePageTest < IT
    include UserHelpers

    def setup
      super
      sign_in_user 'zbigniew.humeniuk@example.com', 'secret'
    end

    test 'should create article' do
      sleep 0.1
      click_on 'New Article'
      try_add_invalid_article
      assert page.has_content? "can't be blank"
      assert page.has_content? 'Article contains strong language.'
      add_valid_article
      txt = 'Article was successfully created.'
      assert page.has_selector? "input[type=submit][value='#{txt}']"
    end

    private

    def try_add_invalid_article
      fill_in 'Text', with: 'maaan.. fuck it'
      click_button 'Create Article'
    end

    def add_valid_article
      fill_in 'Title', with: 'Article #1'
      fill_in 'Text', with: 'The Ruby I18n (shorthand for internationalization) ' \
                            'gem which is shipped with Ruby on Rails (starting from Rails 2.2) provides an ' \
                            'easy-to-use and extensible framework for translating your application to a single ' \
                            'custom language other than English or for providing multi-language support in your ' \
                            "application. The process of 'internationalization' usually means to abstract all " \
                            'strings and other locale specific bits (such as date or currency formats) out of ' \
                            "your application. The process of 'localization' means to provide translations and " \
                            'localized formats for these bits.'
      click_button 'Create Article'
    end
  end
end
