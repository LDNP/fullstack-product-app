Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
  
  # API routes
  resources :products
  
  # Static files from React
  get '/static/*path', to: 'static_files#serve_static'
  get '/favicon.ico', to: 'static_files#serve_static'
  get '/logo192.png', to: 'static_files#serve_static'
  get '/logo512.png', to: 'static_files#serve_static'
  get '/manifest.json', to: 'static_files#serve_static'
  
  # React app fallback route
  get 'react-client', to: 'application#react_client', format: false
  get 'react-client/*path', to: 'application#react_client', format: false
  
  # Root route
  root "products#index"
end
