# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionCheckerTest < TC
    include WsHelpers

    before do
      @org_expiration = WsConnectionManager::EXPIRATION
      Kernel.silence_warnings { WsConnectionManager::EXPIRATION = 1 }
      create_connection(admins(:one), 'UUID#3')
    end

    after do
      Kernel.silence_warnings { WsConnectionManager::EXPIRATION = @org_expiration }
    end

    describe 'a connections status is "ok"' do
      before do
        assert_equal 'ok', WsConnectionStorage.current.get('UUID#3')
      end

      it 'does not change the status' do
        WsConnectionChecker.call(WsConnectionIdentifier.call(admins(:one)))
        assert_equal 'ok', WsConnectionStorage.current.get('UUID#3')
      end
    end

    describe 'a connections status is nil' do
      before do
        sleep(2)
        assert_nil WsConnectionStorage.current.get('UUID#3')
      end

      it 'changes a status to "verification"' do
        WsConnectionChecker.call(WsConnectionIdentifier.call(admins(:one)))
        assert_equal 'verification', WsConnectionStorage.current.get('UUID#3')
      end
    end
  end
end
