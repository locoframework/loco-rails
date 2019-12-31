# frozen_string_literal: true

Rails.application.routes.draw do
  mount Loco::Engine => '/notification-center'

  namespace :user do
    resources :sessions, only: %i[new create destroy]
    resources :articles do
      member do
        put :publish
      end
      resources :comments, except: %i[new create]
    end
    resources :rooms, only: %i[index new create show destroy] do
      member do
        patch :join
        patch :leave
      end
      resources :members, only: [:index]
    end
    get 'members/index'
    root 'articles#index'
  end

  scope module: 'main' do
    resources :users, only: %i[new create]
    resources :articles, only: %i[index show] do
      resources :comments, only: %i[index create show] do
        collection do
          get :count
        end
      end
    end
  end

  namespace :admin do
    resources :users
    resources :sessions, only: %i[new create destroy]
    resources :articles, only: %i[show edit update] do
      collection do
        get :published
      end
      resources :comments, only: %i[index show edit update]
    end
    root 'users#index'
  end

  root 'main/pages#index'
end
