require 'test_helper'

class User::DirectCommunicationTest < IT
  include Loco::Emitter
  include UserHelpers

  def setup
    super
    sign_in_user 'zbigniew.humeniuk@example.com', 'secret'
  end

  test "should show an alert" do
    sleep 0.1
    emit_to users(:user_zbig), signal: 'ping'
    assert_equal 'Ping!', page.driver.browser.switch_to.alert.text
    page.driver.browser.switch_to.alert.accept
  end
end