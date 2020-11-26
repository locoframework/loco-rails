# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionCheckerTest < TCWithMocks
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

      it 'does not trigger a background job' do
        expect(SenderJob).to_not receive(:perform_later)
        WsConnectionChecker.call(WsConnectionIdentifier.call(admins(:one)))
      end
    end

    describe 'a connections status is nil' do
      before do
        sleep(2)
        assert_nil WsConnectionStorage.current.get('UUID#3')
      end

      it 'changes a status to "verification" and triggers a background job' do
        expect(SenderJob).to receive(:perform_later).with('UUID#3', loco: { connection_check: true })
        WsConnectionChecker.call(WsConnectionIdentifier.call(admins(:one)))
        assert_equal 'verification', WsConnectionStorage.current.get('UUID#3')

        expect(SenderJob).to_not receive(:perform_later)
        WsConnectionChecker.call(WsConnectionIdentifier.call(admins(:one)))
        assert_equal 'verification', WsConnectionStorage.current.get('UUID#3')
      end
    end
  end
end
