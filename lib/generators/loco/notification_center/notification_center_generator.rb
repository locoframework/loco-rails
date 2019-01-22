# frozen_string_literal: true

module Loco
  class NotificationCenterGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def create_dir_with_file
      directory '.', Rails.root.join('app')
    end
  end
end
