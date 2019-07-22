# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  #################
  # Common routes #
  #################

  root to: 'home#show'

  resources :accounts, param: :nickname, only: :show

  resources :federal_subjects, param: :number, only: %i[index show]

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
    resources :roles, only: %i[index destroy]
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

    resources :people, only: %i[index show] do
      resources :person_comments,
                path: 'comments',
                controller: 'people/person_comments',
                only: %i[index create]

      resources :passports,
                controller: 'people/passports',
                only: :index
    end
  end
end
