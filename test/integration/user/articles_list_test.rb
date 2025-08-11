# frozen_string_literal: true

require 'test_helper'

class User
  class ArticlesListTest < IT
    include CommonHelpers
    include UserHelpers

    def setup
      super
      sign_in_user 'zbigniew.humeniuk@example.com', 'secret'
    end

    test 'should auto update the list to include a recently added article' do
      sleep 0.5
      create_article_for :zbig
      assert page.has_content? 'Article #1'
      assert page.has_content? 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
    end

    test 'should update published on the list' do
      visit '/user/articles'
      assert_selector "#article_#{articles(:two).id}", wait: 5
      articles(:two).publish
      Loco.emit articles(:two), :updated, for: [users(:zbig)]
      within "#article_#{articles(:two).id} td.published" do
        assert_text 'yes', wait: 5
      end
    end

    test 'should update title of updated article on the list' do
      visit '/user/articles'
      assert_selector "#article_#{articles(:two).id}", wait: 5
      update_article :two
      assert_selector "#article_#{articles(:two).id} .title", text: 'WiAR', wait: 5
    end

    test 'should remove article from the list on destroy' do
      title = articles(:one).title
      destroy_article :one
      assert_not page.has_content? title
    end

    test 'should update number of comments if one was added' do
      sleep 0.5
      create_comment_for_article :one
      within "#article_#{articles(:one).id} td.comments_quantity" do
        assert page.has_content? '1'
      end
    end

    test 'should update number of comments if one was deleted' do
      sleep 0.1
      comment = create_comment_for_article :one
      within "#article_#{articles(:one).id} td.comments_quantity" do
        assert page.has_content? '1'
      end
      destroy_comment comment
      within "#article_#{articles(:one).id} td.comments_quantity" do
        assert page.has_content? '0'
      end
    end

    private

    def create_article_for(user_name)
      article = users(user_name).articles.new(
        title: 'Article #1',
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.' * 2
      ).tap(&:save!)
      Loco.emit article, :created, for: [users(user_name)]
      article
    end

    def destroy_article(name)
      articles(name).tap do |article|
        article.destroy
        Loco.emit article, :destroyed, for: [users(:zbig)]
      end
    end
  end
end
