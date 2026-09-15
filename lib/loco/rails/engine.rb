# frozen_string_literal: true

module Loco
  class Engine < ::Rails::Engine
    isolate_namespace Loco

    initializer 'loco.helpers' do
      ActiveSupport.on_load(:action_view) { include Loco::Helpers }
    end

    # Before the action queries anything, so `as_of` can never be later than
    # the data a snapshot rendered from it contains.
    initializer 'loco.current' do
      ActiveSupport.on_load(:action_controller_base) do
        prepend_before_action { Loco::Current.as_of = Time.current }
      end
    end
  end
end
