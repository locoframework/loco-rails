# frozen_string_literal: true

require 'test_helper'

module Loco
  class UuidManagerTest < TCWithMocks
    before do
      @ws_conn_manager = Loco::WsConnectionManager.new(users(:zbig))
      @uuid = SecureRandom.uuid
    end

    describe '#add' do
      it do
        expect(@ws_conn_manager).to receive(:add).with(@uuid)
        UuidManager.dispatch('add', @uuid, @ws_conn_manager)
      end
    end
  end
end
