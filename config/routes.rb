# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'devices#index'

  devise_for :users

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
  resources :broker_accounts
  resources :broker_acls
  resources :provision_requests

#  namespace :api, defaults: { format: :json} do
  namespace :api do
    resources :auth
    resources :provision_requests
    resources :devices
    resources :networks
  end

  get '/search', to: 'search#index'

  get '/network/:id/monitor', to: 'networks#monitor'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development? || ENV['USE_LETTEROPENER']

  authenticate :user, ->(user) { user.site_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
