require 'test_helper'

class MainPageTest < IT
  setup do
    visit '/'
  end

  test "should async load articles" do
    assert page.has_content? 'A Guide to Testing Rails Applications'
  end
end

