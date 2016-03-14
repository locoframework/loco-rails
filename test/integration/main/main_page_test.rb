require 'test_helper'

class Main::MainPageTest < IT
  def setup
    super
    visit '/'
  end

  test "should async load articles" do
    assert page.has_content? 'A Guide to Testing Rails Applications'
  end

  test "should async load published article" do
    skip "TODO: implement!"
  end
end