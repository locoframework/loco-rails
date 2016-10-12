Loco::Config.configure({
  silence_logger: false,   # false by default
  notifications_size: 10,  # 100 by default
  app_name: "loco_#{Rails.env}"         # your app's name (required for namespacing)
})