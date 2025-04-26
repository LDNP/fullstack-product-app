Rails.application.routes.draw do
  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  resources :products

  # Static files for React frontend
  get '/react-client/static/*path', to: 'static_files#serve_static'
  get '/react-client/manifest.json', to: 'static_files#serve_static'
  get '/react-client/favicon.ico', to: 'static_files#serve_static'
  get '/react-client/logo192.png', to: 'static_files#serve_static'
  get '/react-client/logo512.png', to: 'static_files#serve_static'

  # React entry points
  get '/react-client', to: redirect('/react-client/index.html')
  get '/react-client/*path', to: 'static_files#serve_static'

  # Root route (HTML frontend)
  root "products#index"
end
