# frozen_string_literal: true

require 'silencer/rails/logger'

Rails.application.configure do
  config.middleware.swap(
    Rails::Rack::Logger,
    Silencer::Logger,
    config.log_tags,
    silence: [%r{^/notification-center}, %r{^/cable}]
  )
end
