Rails.application.routes.draw do
  get "device_data/create"
  get "device_data/destroy"
  # Active les routes Devise pour User, ce qui va générer notamment :
  # new_user_registration_path, new_user_session_path, etc.
  devise_for :users

  resources :devices do
    member do
      post :request_deletion
      patch :toggle  
    end
    resources :device_data, only: [:create, :update, :destroy]
  end
  
  
  resources :users, only: [:index, :show]
  resources :services

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Pages statiques
  root "static_pages#home"
  get "a-propos", to: "static_pages#about", as: :about
  get "contact",  to: "static_pages#contact", as: :contact
  get "mentions-legales", to: "static_pages#legal", as: :legal

  # Module admin
  namespace :admin do
    resources :categories
    resources :users, only: [:index, :edit, :update, :destroy]
    get '/' => 'dashboard#index', as: :dashboard
    get 'reports', to: 'reports#index', as: :reports
  end  # fin du namespace admin
  resources :usage_reports, only: [:index] do
    collection do
      get :admin
    end
  end
  


end
