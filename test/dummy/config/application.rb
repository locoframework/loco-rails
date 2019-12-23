# frozen_string_literal: true

require_relative 'boot'

%w[
  active_model/railtie
  active_job/railtie
  active_record/railtie
  action_controller/railtie
  action_view/railtie
  action_cable/engine
  sprockets/railtie
  rails/test_unit/railtie
].each do |railtie|
  require railtie
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'loco-rails'
require 'jbuilder'
require 'will_paginate'

module Dummy
  class Application < Rails::Application
    config.load_defaults 6.0
  end
end
