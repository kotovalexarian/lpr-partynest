# frozen_string_literal: true

When 'I try to sign in with email {string} ' \
     'and password {string}' do |email, password|
  visit '/users/sign_in'

  fill_in 'Email',  with: email
  fill_in 'Пароль', with: password

  click_on 'Войти'
end

Then 'I am signed in as {string}' do |email|
  expect(page).to have_css 'ul > li > a', visible: false, text: email
end

Then 'I fail to sign in' do
  expect(page.current_path).to eq '/users/sign_in'
  expect(page).to have_css 'div.alert.alert-warning',
                           text: 'Неправильный Email или пароль.'
end
