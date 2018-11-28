# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#show'

  get '/events/2018/11/24/otkrytaja-vstrecha-storonnikov-libertarianskoj-partii.html' => 'home#event1'

  resources :membership_applications, only: %i[new create]
end
