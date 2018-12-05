# frozen_string_literal: true

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

  resources :membership_applications, only: %i[show new create]

  resources :passports, only: %i[index show new create] do
    resources :passport_confirmations,
              controller: 'passports/passport_confirmations',
              only:       %i[index create]
  end

  resources :telegram_bot_updates, only: :create
end
