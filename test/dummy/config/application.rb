# frozen_string_literal: true

require_relative 'boot'

%w[
  active_record/railtie
  action_controller/railtie
  action_view/railtie
  active_job/railtie
  action_cable/engine
  rails/test_unit/railtie
].each do |railtie|
  require railtie
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'sprockets/railtie'
require 'loco-rails'
require 'jbuilder'
require 'will_paginate'
require 'redis'

module Dummy
  class Application < Rails::Application
    config.load_defaults 7.0
  end
end
