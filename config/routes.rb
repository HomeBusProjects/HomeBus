Rails.application.routes.draw do
  resources :spaces
  resources :devices
  resources :mosquitto_accounts
  resources :mosquitto_acls
  resources :provision_requests do
    member do
      get 'accept'
      get 'deny'
      get 'revoke'
    end
  end

  post '/provision', to: 'provision#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
