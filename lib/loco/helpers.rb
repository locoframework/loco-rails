# frozen_string_literal: true

module Loco
  module Helpers
    def loco_body_data
      { 'data-namespace' => namespace_name,
        'data-controller' => controller_name.split('_').map(&:capitalize).join(""),
        'data-action' => action_name,
        'data-rails-env' => Rails.env,
        'data-user-agent' => request.user_agent
      }
    end

    private

      def namespace_name
        path = controller_path.split '/'
        if path.size > 1
          path.first
        else
          "Main"
        end.capitalize
      end
  end
end