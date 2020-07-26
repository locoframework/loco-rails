# frozen_string_literal: true

Loco.configure do |c|
  c.silence_logger = false          # false by default
  c.notifications_size = 100        # 100 by default
  c.app_name = "loco_#{Rails.env}"  # your app's name (required for namespacing)
end
