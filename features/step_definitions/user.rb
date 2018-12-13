# frozen_string_literal: true

Given 'a user with email {string} and password {string}' do |email, password|
  create :user, email: email, password: password
end

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
  click_on @user.email
  click_on 'Выйти'
end

When 'I follow confirmation link for email {string}' do |email|
  user = User.find_by! email: email
  visit user_confirmation_path confirmation_token: user.confirmation_token
end

Then 'I am signed in as {string}' do |email|
  expect(page).to have_css 'ul > li > a', text: email
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
  expect(page).not_to have_text @user.email
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

Then 'I received confirmation email as {string}' do |email|
  mail = ActionMailer::Base.deliveries.last
  token = User.find_by!(email: email).confirmation_token

  expect(mail.from).to eq %w[no-reply@libertarian-party.com]
  expect(mail.to).to eq [email]
  expect(mail.subject).to eq 'Инструкции по подтверждению учетной записи'
  expect(mail.body.to_s.split.join(' ')).to eq <<~TEXT.split("\n").join(' ')
    <p>Здравствуйте, #{email} !</p>
    <p>Вы можете активировать свою учетную запись, нажав ссылку снизу:</p>
    <p>
    <a href="http://localhost:3000/users/confirmation?confirmation_token=#{token}">Активировать</a>
    </p>
  TEXT
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
