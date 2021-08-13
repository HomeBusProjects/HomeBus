# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'devices#index'

  devise_for :users

  resources :provision_requests
  resources :networks
  resources :devices
  resources :tokens
  resources :network_monitors
  resources :public_networks
  resources :public_devices
  resources :apps
  resources :app_instances
  resources :broker_accounts
  resources :ddcs

  namespace :api do
    resources :auth
    resources :provision_requests
    resources :devices
    resources :networks
    resources :network_monitors
  end

  get '/search', to: 'search#index'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development? || ENV['USE_LETTEROPENER']

  authenticate :user, ->(user) { user.site_admin? } do
    resources :app_servers
    resources :brokers
    resources :permissions
    resources :broker_acls
    resources :users

    mount Sidekiq::Web => '/sidekiq'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
