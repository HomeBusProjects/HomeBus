Rails.application.routes.draw do
  resources :permissions
  resources :apps
  resources :app_servers
  resources :ddcs
  resources :brokers
  resources :networks
  devise_for :users
  root to: 'devices#index'

  resources :devices
  resources :users
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
  post '/provision/refresh', to: 'provision#refresh'
  post '/provision/broker', to: 'provision#broker'
  post '/provision/ddcs', to: 'provision#ddcs'

  get '/cleardb', to: 'admin#clear_db'
  get '/search', to: 'search#index'

  get '/network/:id/monitor', to: 'networks#monitor'

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
