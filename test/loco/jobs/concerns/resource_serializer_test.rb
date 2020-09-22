# frozen_string_literal: true

require 'test_helper'

module Loco
  module Jobs
    class ResourceSerializerTest < TC
      before do
        @user = users(:zbig)
        @product = { 'class' => 'User', 'id' => @user.id }
      end

      describe '#serialize' do
        it do
          assert_equal @product, ResourceSerializer.serialize(@user)
        end
      end

      describe '#deserialize' do
        it do
          assert_equal @user, ResourceSerializer.deserialize(@product)
        end
      end
    end
  end
end
