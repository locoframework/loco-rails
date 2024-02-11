# frozen_string_literal: true

module Loco
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def install
      generate 'loco:initializer'
      generate 'loco:file_injector'
      generate 'loco:notification_center'
      rake 'loco:install:migrations'
    end
  end
end
