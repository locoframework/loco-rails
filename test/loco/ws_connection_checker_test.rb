# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionCheckerTest < TC
    include WsHelpers

    before do
      @org_expiration = WsConnectionManager::EXPIRATION
      WsConnectionManager::EXPIRATION = 1
      create_connection(admins(:one), 'UUID#3')
    end

    after do
      WsConnectionManager::EXPIRATION = @org_expiration
    end

    it do
      WsConnectionChecker.call(WsConnectionIdentifier.call(admins(:one)))
      assert_equal 'ok', WsConnectionStorage.current.get('UUID#3')
      sleep(2)
      WsConnectionChecker.call(WsConnectionIdentifier.call(admins(:one)))
      assert_equal 'verification', WsConnectionStorage.current.get('UUID#3')
    end
  end
end
