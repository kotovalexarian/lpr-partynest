# frozen_string_literal: true

Then 'I see membership application creation form' do
  expect(page.current_path).to eq '/join'

  expect(page).to have_field 'Фамилия'
  expect(page).to have_field 'Имя'
  expect(page).to have_field 'Отчество'
end

Then 'I see the membership application tracking page' do
  expect(page.current_path).to eq '/application'
  expect(page).to have_css 'h1', text: 'Ваше заявление в обработке'
  expect(page).to have_css(
    'p.lead',
    text: <<~TEXT.split("\n").join(' '),
      На данной странице вы можете отслеживать статус вашего заявления.
      Сохраните её в закладки браузера. Также на указанный вами адрес
      электронной почты была отправлена ссылка на данную страницу.
      В ближайшее время с вами свяжутся по указанным вами контактам.
    TEXT
  )
end

Then 'I see that I am already a party member' do
  expect(page.current_path).to eq '/application'
  expect(page).to have_css 'h1', text: 'Поздравляем!'
  expect(page).to have_css 'p.lead',
                           text: 'Вы уже являетесь членом или сторонником ' \
                                 'Либертарианской партии России!'
end

When 'I send a membership application' do
  visit '/join'

  within 'form' do
    fill_in 'Фамилия',                   with: Faker::Name.last_name
    fill_in 'Имя', match: :prefer_exact, with: Faker::Name.first_name
    fill_in 'Адрес электронной почты',   with: Faker::Internet.email
    fill_in 'Телефон',                   with: Faker::PhoneNumber.phone_number

    click_on 'Отправить заявление'
  end
end
