# frozen_string_literal: true

Given 'I am signed in with email {string}' do |email|
  @user = create :user, email: email

  visit '/users/sign_in'

  within 'form' do
    fill_in 'Email',  with: @user.email
    fill_in 'Пароль', with: @user.password

    click_on 'Войти'
  end

  expect(page).to have_css 'ul > li > a', text: @user.email
end

When 'I try to sign out' do
  click_on @user.email
  click_on 'Выйти'
end

Then 'I am successfully signed out' do
  expect(page.current_path).to eq '/'
  expect(page).not_to have_text @user.email
  expect(page).to have_text 'Выход из системы выполнен.'
end
