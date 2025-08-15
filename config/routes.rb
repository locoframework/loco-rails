# frozen_string_literal: true

Loco::Engine.routes.draw do
  get 'sync-time' => 'notification_center#sync_time' # TODO: delete
  root 'notification_center#index'
end
