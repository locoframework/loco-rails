# frozen_string_literal: true

module Loco
  class Config
    cattr_accessor(:log_level) { :info }
    cattr_accessor(:notifications_size) { 100 }
    cattr_accessor(:app_name) { "loco_#{Rails.env}" }
    cattr_accessor(:redis_instance)
    cattr_accessor(:resources) { ->(_ctx) { [] } }
  end
end
