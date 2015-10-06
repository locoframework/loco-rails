Loco::Engine.routes.draw do
  get "notification-center" => "notification_center#index"
  root "notification_center#index"
end
