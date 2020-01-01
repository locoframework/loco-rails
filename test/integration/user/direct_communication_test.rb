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
      perform_enqueued_jobs
      emit_to users(:user_zbig), signal: 'ping'
      perform_enqueued_jobs
      sleep 0.1
      assert_equal 'Ping!', page.driver.browser.switch_to.alert.text
      page.driver.browser.switch_to.alert.accept
    end
  end
end
