# frozen_string_literal: true

require 'test_helper'

class DisconnectionTest < IT
  include CapybaraOffline

  def setup
    super
    visit '/'
    go_disconnected
  end

  def teardown
    super
    go_connected
  end

  test 'should show alert about disconnection from the server' do
    page.evaluate_script 'window.test.Env.loco.getWire().allowedDisconnectionTime = 1;'
    msg = 'You have been disconnected from the server for too long. Reload page!'
    assert page.has_content? msg
  end
end
