class Loco::FileInjectorGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def js_manifest
    file_path = File.join Rails.root, 'app', 'assets', 'javascripts', 'application.js'
    gsub_file file_path, /^\/\/= require_tree .$/, ''
    gsub_file file_path, /^\n$/, ''
    if Rails.version.to_f >= 5
      gsub_file file_path, "//= require cable\n", ''
      gsub_file file_path, "//= require cable", ''
    end
    data = File.read find_in_source_paths('application.js')
    append_file file_path, data
    if Rails.version.to_f >= 5
      inject_into_file file_path, "//= require cable\n", after: "//= require loco-rails\n"
    end
  end

  def routes
    file_path = File.join Rails.root, 'config', 'routes.rb'
    line = %Q{  mount Loco::Engine => '/notification-center'\n\n}
    inject_into_file file_path, line, after: "Rails.application.routes.draw do\n"
  end

  def application_helper
    file_path = File.join Rails.root, 'app', 'helpers', 'application_helper.rb'
    line = %Q{  include Loco::Helpers\n}
    inject_into_file file_path, line, after: "module ApplicationHelper\n"
  end

  def layout
    file_path = File.join Rails.root, 'app', 'views', 'layouts', 'application.html.erb'
    gsub_file file_path, '<body>', '<%= content_tag :body, loco_body_data do %>'
    gsub_file file_path, '</body>', '<% end %>'
  end

  def application_controller
    file_path = File.join Rails.root, 'app', 'controllers', 'application_controller.rb'
    data = File.read find_in_source_paths('application_controller.rb')
    after_line = "class ApplicationController < ActionController::Base\n"
    inject_into_file file_path, data, after: after_line
  end

  def connection
    return if Rails.version.to_f < 5
    file_path = File.join Rails.root, 'app', 'channels', 'application_cable', 'connection.rb'
    data = File.read find_in_source_paths('connection.rb')
    inject_into_class file_path, 'Connection', data
  end
end
