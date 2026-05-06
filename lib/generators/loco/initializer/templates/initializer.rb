# frozen_string_literal: true

Loco.configure do |c|
  c.log_level = :info               # :info by default — set :error to silence Loco's controller noise
  c.notifications_size = 100        # 100 by default
  c.app_name = "loco_#{Rails.env}"  # your app's name (required for namespacing)

  # Signed-in resources Loco should be aware of. Called with the current
  # context (controller or ActionCable connection). Must return an array.
  c.resources = ->(ctx) { [ctx.try(:current_user), ctx.try(:current_admin)] }
end
