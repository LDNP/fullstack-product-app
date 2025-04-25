Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  resources :products

  get 'react-client', to: 'application#react_client', format: false
  get 'react-client/*path', to: 'application#react_client', format: false


  # Root route
  root "products#index"
end
