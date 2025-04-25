Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  resources :products

  # React app fallback route (for /react or /react/anything)
  get 'react-client/*path', to: 'application#react_client', format: false

  # Root route
  root "products#index"
end
