Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Enable all standard CRUD routes for Products
  resources :products

   # Route to serve the React frontend
   get 'react', to: redirect('/react-client/index.html')
   get 'react/*path', to: redirect('/react-client/index.html')

  # Defines the root path route ("/")
  root "products#index"
end
