# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'home#show'

  devise_for :users, controllers: {
    sessions:           'users/sessions',
    registrations:      'users/registrations',
    confirmations:      'users/confirmations',
    passwords:          'users/passwords',
    unlocks:            'users/unlocks',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

  resources :membership_apps, only: %i[show new create]

  namespace :settings do
    resources :telegram_contacts, only: :index
  end

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

    resources :telegram_bots, only: %i[index show]
    resources :telegram_chats, only: %i[index show]
  end

  resources :telegram_bots, only: [] do
    resources :updates,
              controller: 'telegram_bots/updates',
              only:       :create
  end
end
