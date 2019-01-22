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

    def application_helper
      file_path = Rails.root.join 'app', 'helpers', 'application_helper.rb'
      line = %(  include Loco::Helpers\n)
      inject_into_file file_path, line, after: "module ApplicationHelper\n"
    end

    def layout
      gsub_file(
        layout_path,
        '<body>',
        '<%= content_tag :body, loco_body_data do %>'
      )
      gsub_file layout_path, '</body>', '<% end %>'
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
      return if Rails.version.to_f < 5
      file_path = Rails.root.join(
        'app',
        'channels',
        'application_cable',
        'connection.rb'
      )
      data = File.read find_in_source_paths('connection.rb')
      inject_into_class file_path, 'Connection', data
    end

    def layout_path
      Rails.root.join(
        'app',
        'views',
        'layouts',
        'application.html.erb'
      )
    end
  end
end
