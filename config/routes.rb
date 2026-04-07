# frozen_string_literal: true

Loco::Engine.routes.draw do
  get 'sync-time' => 'notification_center#sync_time' # TODO: delete in the 7.1 release
  root 'notification_center#index'
end
