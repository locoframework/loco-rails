Rails.application.routes.draw do
  mount Loco::Engine => "/notification-center"

  namespace :user do
    resources :sessions, only: [:new, :create, :destroy]
    resources :articles do
      member do
        put :publish
      end
      resources :comments, except: [:new, :create]
    end
    root "articles#index"
  end

  scope module: 'main' do
    resources :users, only: [:new, :create]
    resources :articles, only: [:index, :show] do
      resources :comments, only: [:index, :create, :show]
    end
  end

  namespace :admin do
    resources :users
    resources :sessions, only: [:new, :create, :destroy]
    root "users#index"
  end

  root "main/pages#index"
end
