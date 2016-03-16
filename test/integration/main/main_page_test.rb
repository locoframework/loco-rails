require 'test_helper'

class Main::MainPageTest < IT
  include Loco::Emitter

  def setup
    super
    visit '/'
  end

  test "should async load articles" do
    assert page.has_content? 'A Guide to Testing Rails Applications'
  end

  test "should auto load published article" do
    publish_article :two
    assert page.has_content? 'What is Active Record?'
  end

  test "should update title of recently updated article" do
    articles(:one).tap do |a|
      a.title = 'AGtTRA'
      a.save!
    end
    emit articles(:one), :updated, for: [:all]
    assert page.has_content? 'AGtTRA'
  end

  private

    def publish_article name
      articles(name).publish
      emit articles(name), :published, data: {id: articles(name).id}
    end
end