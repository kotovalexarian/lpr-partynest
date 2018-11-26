# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#show'

  resources :membership_applications, only: %i[new create]
end
