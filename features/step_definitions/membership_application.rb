# frozen_string_literal: true

Then 'I see membership application creation form' do
  expect(page.current_path).to eq '/join'

  expect(page).to have_field 'Фамилия'
  expect(page).to have_field 'Имя'
  expect(page).to have_field 'Отчество'
end

Then 'I see the membership application tracking page' do
  expect(page.current_path).to match %r{\A/membership_apps/\d+\z}
  expect(page).to have_css 'h2', text: 'Ваше заявление в обработке'
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
