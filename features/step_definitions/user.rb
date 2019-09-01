# frozen_string_literal: true

Given 'a user with email {string} and password {string}' do |email, password|
  create :user, email: email, password: password
end

Given 'I am signed in as superuser' do
  @account = create :superuser_account

  visit '/users/sign_in'

  within 'form' do
    fill_in 'Email',  with: @account.user.email
    fill_in 'Пароль', with: @account.user.password

    click_on 'Войти'
  end

  expect(page).to have_css 'ul > li > a', text: @account.nickname
end

Given 'I am signed in with email {string}' do |email|
  @account = create(:user, email: email).account

  visit '/users/sign_in'

  within 'form' do
    fill_in 'Email',  with: @account.user.email
    fill_in 'Пароль', with: @account.user.password

    click_on 'Войти'
  end

  expect(page).to have_css 'ul > li > a', text: @account.nickname
end

Given 'I am signed in with email {string} ' \
      'and password {string}' do |email, password|
  @account = create(:user, email: email, password: password).account

  visit '/users/sign_in'

  within 'form' do
    fill_in 'Email',  with: @account.user.email
    fill_in 'Пароль', with: @account.user.password

    click_on 'Войти'
  end

  expect(page).to have_css 'ul > li > a', text: @account.nickname
end

Given 'I am signed in as party supporter' do
  @person = create :supporter_person
  @account = create :usual_account, person: @person

  visit '/users/sign_in'

  within 'form' do
    fill_in 'Email',  with: @account.user.email
    fill_in 'Пароль', with: @account.user.password

    click_on 'Войти'
  end

  expect(page).to have_css 'ul > li > a', text: @account.nickname
end

Given 'I am signed in as party member' do
  @person = create :member_person
  @account = create :usual_account, person: @person

  visit '/users/sign_in'

  within 'form' do
    fill_in 'Email',  with: @account.user.email
    fill_in 'Пароль', with: @account.user.password

    click_on 'Войти'
  end

  expect(page).to have_css 'ul > li > a', text: @account.nickname
end

Given 'I am signed in as excluded party member' do
  @person = create :excluded_person
  @account = create :usual_account, person: @person

  visit '/users/sign_in'

  within 'form' do
    fill_in 'Email',  with: @account.user.email
    fill_in 'Пароль', with: @account.user.password

    click_on 'Войти'
  end

  expect(page).to have_css 'ul > li > a', text: @account.nickname
end

When 'I try to sign in with email {string} ' \
     'and password {string}' do |email, password|
  visit '/users/sign_in'

  within 'form' do
    fill_in 'Email',  with: email
    fill_in 'Пароль', with: password

    click_on 'Войти'
  end
end

When 'I try to sign out' do
  click_on @account.nickname
  click_on 'Выйти'
end

When 'I follow confirmation link for email {string}' do |email|
  user = User.find_by! email: email
  visit user_confirmation_path confirmation_token: user.confirmation_token
end

Then 'I am signed in as {string}' do |email|
  user = User.find_by! email: email
  expect(page).to have_css 'ul > li > a', text: user.account.nickname
end

Then 'I fail to sign in' do
  expect(page.current_path).to eq '/users/sign_in'
  expect(page).to have_css 'div.alert.alert-warning',
                           text: 'Неправильный Email или пароль.'
end

Then 'I fail to sign in because of unconfirmed email' do
  expect(page.current_path).to eq '/users/sign_in'
  expect(page).to have_css 'div.alert.alert-warning',
                           text: 'Вы должны подтвердить вашу учетную запись.'
end

Then 'I am successfully signed out' do
  expect(page.current_path).to eq '/'
  expect(page).not_to have_text @account.user.email if @account.user
  expect(page).to have_text 'Выход из системы выполнен.'
end

Then 'I am successfully signed up, but my email is unconfirmed' do
  expect(page.current_path).to eq '/'
  expect(page).to have_css 'h1', text: 'Либертарианская партия России'

  expect(page).to have_css(
    'div.alert.alert-info',
    text: 'Письмо со ссылкой для подтверждения было отправлено '      \
          'на ваш адрес эл. почты. Пожалуйста, перейдите по ссылке, ' \
          'чтобы подтвердить учетную запись.',
  )
end

Then 'I see that my email is confirmed' do
  expect(page.current_path).to eq '/users/sign_in'
  expect(page).to have_css 'div.alert.alert-info',
                           text: 'Ваш адрес эл. почты успешно подтвержден.'
end

Then 'the password is successfully changed' do
  expect(page.current_path).to eq '/users/edit'
  expect(page).to have_css 'div.alert.alert-info',
                           text: 'Ваша учетная запись изменена.'
end

Then 'the password is failed to change' do
  expect(page.current_path).to eq '/users'
  expect(page).to have_css 'div.alert.alert-danger',
                           text: 'Пожалуйста, исправьте следующие ошибки:'
end
