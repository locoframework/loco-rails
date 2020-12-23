# frozen_string_literal: true

require 'test_helper'

class User
  class DirectCommunicationTest < IT
    include Loco::Emitter
    include UserHelpers

    def setup
      super
      sign_in_user 'zbigniew.humeniuk@example.com', 'secret'
    end

    test 'should show an alert' do
      sleep 0.1
      emit_to users(:zbig), type: 'PING'
      sleep 0.1
      assert_equal 'Ping!', page.driver.browser.switch_to.alert.text
      page.driver.browser.switch_to.alert.accept
    end
  end
end
