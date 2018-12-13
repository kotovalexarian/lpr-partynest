# frozen_string_literal: true

Given 'I am signed in with email {string} ' \
      'and password {string}' do |email, password|
  @user = create :user, email: email, password: password

  visit '/users/sign_in'

  within 'form' do
    fill_in 'Email',  with: @user.email
    fill_in 'Пароль', with: @user.password

    click_on 'Войти'
  end

  expect(page).to have_css 'ul > li > a', text: @user.email
end

Then 'the password is successfully changed' do
  expect(page.current_path).to eq '/users/edit'
  expect(page).to have_css 'div.alert.alert-info',
                           text: 'Ваша учетная запись изменена.'
end
