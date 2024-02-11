# frozen_string_literal: true

Loco.configure do |c|
  db = case Rails.env
       when 'development', 'production' then 2
       when 'test' then 12
       end
  c.silence_logger = false          # false by default
  c.notifications_size = 10         # 100 by default
  c.app_name = "loco_#{Rails.env}"  # your app's name (required for namespacing)
  c.redis_instance = Redis.new(host: '127.0.0.1', port: 6380, db:)
end
