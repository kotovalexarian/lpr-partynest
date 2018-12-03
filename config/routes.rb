# frozen_string_literal: true

Rails.application.routes.draw do
  get '/s/452465', to: 'home#event1'
  get '/s/243898', to: 'home#post1'
  get '/s/377295', to: 'home#post2'

  get '/events/2018/11/24/' \
      'otkrytaja-vstrecha-storonnikov-libertarianskoj-partii.html',
      to: 'home#event1'

  get '/posts/2018/07/27/' \
      'sformirovan-rukovodjashhij-komitet-ro-lpr-v-permskom-krae.html',
      to: 'home#post1'

  get '/posts/2018/11/12/' \
      'sekretar-ro-lpr-v-permskom-krae-byl-zaderzhan-na-4-chasa.html',
      to: 'home#post2'

  #####

  root to: 'home#show'

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    registrations: 'users/registrations',
  }

  resources :membership_applications, only: %i[new create]

  resources :passports, only: %i[index show new create] do
    resources :passport_confirmations,
              controller: 'passports/passport_confirmations',
              only:       %i[index create]
  end

  resources :telegram_bot_updates, only: :create
end
