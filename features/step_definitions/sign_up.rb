# frozen_string_literal: true

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

Then 'I fail to sign in because of unconfirmed email' do
  expect(page.current_path).to eq '/users/sign_in'
  expect(page).to have_css 'div.alert.alert-warning',
                           text: 'Вы должны подтвердить вашу учетную запись.'
end

When 'I follow confirmation link for email {string}' do |email|
  user = User.find_by! email: email
  visit user_confirmation_path confirmation_token: user.confirmation_token
end

Then 'I see that my email is confirmed' do
  expect(page.current_path).to eq '/users/sign_in'
  expect(page).to have_css 'div.alert.alert-info',
                           text: 'Ваш адрес эл. почты успешно подтвержден.'
end
