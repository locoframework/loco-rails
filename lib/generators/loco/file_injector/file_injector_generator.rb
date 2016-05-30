class Loco::FileInjectorGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def js_manifest
    file_path = File.join Rails.root, 'app', 'assets', 'javascripts', 'application.js'
    gsub_file file_path, /^\/\/= require_tree .$/, ''
    gsub_file file_path, /^\n$/, ''
    data = File.read find_in_source_paths('application.js')
    append_file file_path, data
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
end
