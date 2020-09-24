# frozen_string_literal: true

require 'test_helper'

module Loco
  class BroadcasterTest < TC
    describe '#emit' do
      it 'can emit to a class of objects' do
        Broadcaster.new(articles(:one), :created, to: Admin).emit
        assert_equal 1, Notification.where(Notification::FOR_CLASS_SQL_TMPL, 'Admin').count
      end
    end
  end
end
