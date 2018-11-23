# frozen_string_literal: true

Rails.application.routes.draw do
  root to: ->(_) { [200, {}, ['Hello, World!']] }

  resources :membership_applications, only: :new
end
