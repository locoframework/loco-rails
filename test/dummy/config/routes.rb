Rails.application.routes.draw do
  namespace :user do
    get 'members/index'
  end

  mount Loco::Engine => "/notification-center"

  namespace :user do
    resources :sessions, only: [:new, :create, :destroy]
    resources :articles do
      member do
        put :publish
      end
      resources :comments, except: [:new, :create]
    end
    resources :rooms, only: [:index, :new, :create, :show, :destroy] do
      member do
        patch :join, :leave
      end
      resources :members, only: [:index]
    end
    root "articles#index"
  end

  scope module: 'main' do
    resources :users, only: [:new, :create]
    resources :articles, only: [:index, :show] do
      resources :comments, only: %i[index create show] do
        collection do
          get :count
        end
      end
    end
  end

  namespace :admin do
    resources :users
    resources :sessions, only: [:new, :create, :destroy]
    resources :articles, only: [:show, :edit, :update] do
      collection do
        get :published
      end
      resources :comments, only: [:index, :show, :edit, :update]
    end
    root "users#index"
  end

  root "main/pages#index"
end
