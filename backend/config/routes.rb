Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  resources :products

  # Add these redirect routes
  get '/static/js/main.57f31694.js', to: redirect('/react-client/static/js/main.caee8d59.js')
  get '/static/css/main.b4559cc8.css', to: redirect('/react-client/static/css/main.b4559cc8.css')
  get '/manifest.json', to: redirect('/react-client/manifest.json')

  # React app fallback route
  get 'react-client', to: 'application#react_client', format: false
  get 'react-client/*path', to: 'application#react_client', format: false

  # Root route
  root "products#index"
end
