# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  #################
  # Common routes #
  #################

  root to: 'home#show'

  get  :join, to: 'membership_apps#new'
  post :join, to: 'membership_apps#create'

  resources :membership_apps, only: :show

  ###############
  # User routes #
  ###############

  devise_for :users, controllers: {
    sessions:           'users/sessions',
    registrations:      'users/registrations',
    confirmations:      'users/confirmations',
    passwords:          'users/passwords',
    unlocks:            'users/unlocks',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

  ##################
  # Account routes #
  ##################

  namespace :settings do
    resources :telegram_contacts, only: :index
  end

  ######################################
  # Callbacks for third-party services #
  ######################################

  resources :telegram_bots, only: [] do
    resources :updates,
              controller: 'telegram_bots/updates',
              only:       :create
  end

  #########################
  # Routes for staff only #
  #########################

  namespace :staff do
    authenticate :user,
                 ->(user) { user.account.can_access_sidekiq_web_interface? } do
      mount Sidekiq::Web, at: '/sidekiq', as: :sidekiq
    end

    get '/sidekiq', to: redirect('/', status: 307), as: :forbidden_sidekiq

    resources :passports, only: %i[index show new create] do
      resources :passport_confirmations,
                controller: 'passports/passport_confirmations',
                only:       %i[index create]
    end

    resources :membership_apps, only: %i[index show]
    resources :telegram_bots, only: %i[index show]
    resources :telegram_chats, only: %i[index show]
  end
end
