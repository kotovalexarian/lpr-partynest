# frozen_string_literal: true

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

Then 'I received password change email as {string}' do |email|
  mail = ActionMailer::Base.deliveries.last

  expect(mail.from).to eq %w[no-reply@libertarian-party.com]
  expect(mail.to).to eq [email]
  expect(mail.subject).to eq 'Пароль изменен'
  expect(mail.body.to_s.split.join(' ')).to eq <<~TEXT.split("\n").join(' ')
    <p>Приветствуем, #{email}!</p>
    <p>Мы пытаемся связаться с вами, что бы сообщить, что ваш пароль был изменен.</p>
  TEXT
end
