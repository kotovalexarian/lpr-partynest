# frozen_string_literal: true

When 'I try to sign in with email {string} ' \
     'and password {string}' do |email, password|
  visit '/users/sign_in'

  fill_in 'Email',  with: email
  fill_in 'Пароль', with: password

  click_on 'Войти'
end
