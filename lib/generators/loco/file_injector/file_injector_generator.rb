# frozen_string_literal: true

module Loco
  class FileInjectorGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def routes
      file_path = Rails.root.join 'config', 'routes.rb'
      line = %(  mount Loco::Engine => '/notification-center'\n\n)
      str = "Rails.application.routes.draw do\n"
      inject_into_file file_path, line, after: str
    end

    def application_controller
      file_path = Rails.root.join(
        'app',
        'controllers',
        'application_controller.rb'
      )
      data = File.read find_in_source_paths('application_controller.rb')
      after_line = "class ApplicationController < ActionController::Base\n"
      inject_into_file file_path, data, after: after_line
    end

    def connection
      file_path = Rails.root.join(
        'app',
        'channels',
        'application_cable',
        'connection.rb'
      )
      data = File.read find_in_source_paths('connection.rb')
      inject_into_class file_path, 'Connection', data
    end
  end
end
