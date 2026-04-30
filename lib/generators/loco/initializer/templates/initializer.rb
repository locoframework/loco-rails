# frozen_string_literal: true

Loco.configure do |c|
  c.log_level = :info               # :info by default — set :error to silence Loco's controller noise
  c.notifications_size = 100        # 100 by default
  c.app_name = "loco_#{Rails.env}"  # your app's name (required for namespacing)
end
