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
        WsConnectionChecker.(WsConnectionIdentifier.(admins(:one)))
        assert_equal 'ok', WsConnectionStorage.current.get('UUID#3')
      end

      it 'does not call WsConnectionManager' do
        expect(WsConnectionManager).to_not receive(:new)
        WsConnectionChecker.(WsConnectionIdentifier.(admins(:one)))
      end
    end

    describe 'a connections status is nil' do
      before do
        @identifier = WsConnectionIdentifier.(admins(:one))
        sleep(2)
        assert_nil WsConnectionStorage.current.get('UUID#3')
      end

      it 'calls out WsConnectionManager' do
        ws_conn_mgr = double('ws_conn_mgr')
        expect(WsConnectionManager).to receive(:new).with(@identifier, identifier: true) do
          ws_conn_mgr
        end
        expect(ws_conn_mgr).to receive(:del).with('UUID#3', skip_checker: true)
        WsConnectionChecker.(@identifier)
      end
    end
  end
end
