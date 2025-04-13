Rails.application.routes.draw do
  resources :devices do
    member do
      post :request_deletion
    end
  end
  
  resources :users, only: [:index, :show]

    

  


  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Pages statiques
  root "static_pages#home"
  get "a-propos", to: "static_pages#about", as: :about
  get "contact",  to: "static_pages#contact", as: :contact
  get "mentions-legales", to: "static_pages#legal", as: :legal

  # Module admin
  namespace :admin do
    get "categories/index"
    get "categories/new"
    get "categories/edit"
    get "categories/show"
    get "categories/create"
    get "categories/update"
    get "categories/destroy"
    get '/' => 'dashboard#index', as: :dashboard
    resources :users, only: [:index, :edit, :update, :destroy]
  end  # ← ce end ferme le namespace
  patch 'devices/:id/toggle', to: 'devices#toggle', as: :toggle_device

  


  
  
  

end  # ← ce end ferme le draw do principal
