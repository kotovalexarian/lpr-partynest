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

Then 'I fail to sign in because of unconfirmed email' do
  expect(page.current_path).to eq '/users/sign_in'
  expect(page).to have_css 'div.alert.alert-warning',
                           text: 'Вы должны подтвердить вашу учетную запись.'
end
