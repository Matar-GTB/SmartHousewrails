Rails.application.routes.draw do
  resources :devices
  devise_for :users

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Pages statiques
  root "static_pages#home"
  get "a-propos", to: "static_pages#about", as: :about
  get "contact",  to: "static_pages#contact", as: :contact
  get "mentions-legales", to: "static_pages#legal", as: :legal

  # Module admin
  namespace :admin do
    get '/' => 'dashboard#index', as: :dashboard
    resources :users, only: [:index, :edit, :update, :destroy]
  end  # ← ce end ferme le namespace

end  # ← ce end ferme le draw do principal
