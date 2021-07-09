# frozen_string_literal: true

Rails.application.routes.draw do
  resources :tokens
  resources :public_networks
  resources :public_devices
  resources :app_instances
  resources :permissions
  resources :apps
  resources :app_servers
  resources :ddcs
  resources :brokers
  resources :networks
  resources :devices
  resources :users
  resources :mosquitto_accounts
  resources :mosquitto_acls
  resources :provision_requests

  namespace :api, defaults: { format: :json} do
    resources :api_provision_requests
  end

  devise_for :users
  root to: 'devices#index'

  # deprecated, to be removed
  post '/provision', to: 'provision#index'
  post '/provision/refresh', to: 'provision#refresh'
  post '/provision/broker', to: 'provision#broker'
  post '/provision/ddcs', to: 'provision#ddcs'

  get '/cleardb', to: 'admin#clear_db'
  get '/search', to: 'search#index'

  get '/network/:id/monitor', to: 'networks#monitor'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development? || ENV['USE_LETTEROPENER']

  authenticate :user, ->(user) { user.site_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
