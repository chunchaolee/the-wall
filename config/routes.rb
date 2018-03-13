Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "events#index"

  # setup events
  resources :events, only: [:index, :show] do

    # All posts of events ; like index
    collection do
      get :posts
    end

  end

  # setup user
  resources :users, only: [:show, :edit, :update]

  # setup interest
  resources :interests, only: [:create, :destroy] 

  # setup admin
  namespace :admin do
    root "events#index"
    resources :events, except: [:show, :new, :create]
    resources :users, only: [:index, :destroy]
  end

end
