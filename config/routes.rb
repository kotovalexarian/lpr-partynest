# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#show'

  get '/events/2018/11/24/otkrytaja-vstrecha-storonnikov-libertarianskoj-partii.html' => 'home#event1'
  get '/posts/2018/11/12/sekretar-ro-lpr-v-permskom-krae-byl-zaderzhan-na-4-chasa.html' => 'home#post2'

  resources :membership_applications, only: %i[new create]
end
