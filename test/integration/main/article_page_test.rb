require 'test_helper'

class Main::ArticlePageTest < IT
  include Loco::Emitter
  include CommonHelpers

  def setup
    super
    visit '/'
    within "#article_#{articles(:one).id}" do
      click_link 'Continued…'
    end
  end

  test "should go to article's page" do
    assert page.has_content? 'No comments.'
  end

  test "should add a comment" do
    try_add_invalid_article
    assert page.has_content? "can't be blank"
    assert page.has_content? "contains strong language."
    add_valid_article
    txt = "Your comment has been posted!"
    assert page.has_selector? "input[type=submit][value='#{txt}']"
    assert page.has_content? '1 comment'
    assert page.has_content? 'Nice article man!'
  end

  test "should show info about editing" do
    sleep 0.1
    emit articles(:one), :updating, data: {mark: Time.current.to_f.to_s}
    assert page.has_content? 'Author is currently editing article. Be aware of possible changes.'
  end

  test "should update number of comments if one was added" do
    within "#comments_count" do
      assert page.has_content? '0 comments'
    end
    create_comment_for_article :one
    within "#comments_count" do
      assert page.has_content? '1 comment'
    end
  end

  test "should update number of comments if one was deleted" do
    within "#comments_count" do
      assert page.has_content? '0 comments'
    end
    comment = create_comment_for_article :one
    within "#comments_count" do
      assert page.has_content? '1 comment'
    end
    destroy_comment comment
    within "#comments_count" do
      assert page.has_content? '0 comments'
    end
  end

  test "should auto load recently added comment" do
    create_comment_for_article :one
    within "section#comments" do
      assert page.has_content? 'Some nice thoughts dude'
    end
  end

  test "should auto update recently updated comment by user" do
    comment = create_comment_for_article :one
    visit "/articles/#{articles(:one).id}"
    within "section#comments" do
      assert_not page.has_content? 'Some nice thoughts dude (edited)'
    end
    update_comment comment
    sleep 0.1
    within "section#comments" do
      assert page.has_content? 'Some nice thoughts dude (edited)'
    end
  end

  test "should auto remove recently deleted comment by user" do
    comment = create_comment_for_article :one
    within "section#comments" do
      assert page.has_content? 'Some nice thoughts dude'
    end
    destroy_comment comment
    sleep 1
    within "section#comments" do
      assert_not page.has_content? 'Some nice thoughts dude'
    end
  end

  test "should auto update article's title and content" do
    within "#title" do
      assert_not page.has_content? '(edited)'
    end
    update_article :one
    within "#title" do
      assert page.has_content? '(edited)'
    end
    within "#text" do
      assert page.has_content? '(edited)'
    end
  end

  private

    def try_add_invalid_article
      fill_in 'comment_text', with: "Fuck this shit!"
      click_button "Post this comment"
    end

    def add_valid_article
      fill_in 'comment_author', with: "David"
      fill_in 'comment_text', with: "Nice article man!"
      click_button "Post this comment"
    end

    def update_article name
      articles(name).tap do |a|
        a.title = "#{a.title} (edited)"
        a.text = "#{a.text} (edited)"
        a.save!
      end
      emit articles(name), :updated, for: [:all]
    end
end