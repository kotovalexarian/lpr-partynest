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

  resources :membership_apps, only: %i[show new create]

  resources :passports, only: %i[index show new create] do
    resources :passport_confirmations,
              controller: 'passports/passport_confirmations',
              only:       %i[index create]
  end

  namespace :settings do
    resources :telegram_contacts, only: :index
  end

  resources :telegram_bots, only: %i[index show] do
    resources :updates,
              controller: 'telegram_bots/updates',
              only:       :create
  end

  resources :telegram_chats, only: %i[index show]
end
