# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  #################
  # Common routes #
  #################

  root to: 'home#show'

  resources :accounts, param: :nickname, only: :show

  resources :federal_subjects, param: :number, only: %i[index show]

  resources :public_keys,
            controller: 'asymmetric_keys',
            only: %i[index show]

  resources :private_keys, only: :show

  ###############
  # User routes #
  ###############

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    unlocks: 'users/unlocks',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

  ##################
  # Account routes #
  ##################

  namespace :settings do
    resource :profile, only: %i[edit update]
    resource :appearance, only: %i[edit update]
    resource :person, only: %i[show new]
    resources :sessions, only: :index

    resources :contacts, only: %i[index create destroy] do
      resource :security_notification_switch,
               controller: 'contacts/security_notification_switches',
               only: :create
    end
  end

  #########################
  # Routes for staff only #
  #########################

  namespace :staff, module: 'staffs' do
    root to: 'home#show'

    authenticate :user,
                 ->(user) { user.account.can_access_sidekiq_web_interface? } do
      mount Sidekiq::Web, at: '/sidekiq', as: :sidekiq
    end

    get '/sidekiq', to: redirect('/', status: 307), as: :forbidden_sidekiq

    resources :contact_networks, only: :index

    resources :accounts, param: :nickname, only: %i[index show]

    resources :x509_certificates, only: %i[index show new create]

    resources :people, only: %i[index show new create] do
      resources :person_comments,
                path: 'comments',
                controller: 'people/person_comments',
                only: %i[index create]

      resources :relationships,
                controller: 'people/relationships',
                only: :index

      resources :passports,
                controller: 'people/passports',
                only: :index

      resource :account_connection_link,
               controller: 'people/account_connection_links',
               only: %i[show create]
    end
  end
end
