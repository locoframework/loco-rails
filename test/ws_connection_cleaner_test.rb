# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionCleanerTest < TCWithMocks
    include WsHelpers

    before do
      @org_expiration = WsConnectionManager::EXPIRATION
      Kernel.silence_warnings { WsConnectionManager::EXPIRATION = 1 }
    end

    after do
      Kernel.silence_warnings { WsConnectionManager::EXPIRATION = @org_expiration }
    end

    it 'calls out WsConnectionManager#del' do
      create_connection(admins(:one), 'UUID#3')
      sleep(1)
      create_connection(admins(:one), 'UUID#3.1')
      WsConnectionChecker.(identifier)
      WsConnectionCleaner.(identifier, 'UUID#3.1')
      assert_equal 'ok', WsConnectionStorage.current.get('UUID#3.1')
      manager = double('ws_conn_manager')
      expect(WsConnectionManager).to receive(:new).with(identifier, identifier: true) { manager }
      expect(manager).to receive(:del).with('UUID#3', skip_checker: true)
      WsConnectionCleaner.(identifier, 'UUID#3')
    end

    private

    def identifier
      WsConnectionIdentifier.(admins(:one))
    end
  end
end
