# frozen_string_literal: true

When 'I visit {string}' do |string|
  visit string
end

When 'I fill form with the following data:' do |table|
  within 'form' do
    table.rows.each do |(key, value)|
      fill_in key, with: value
    end
  end
end

When 'I click the form button {string}' do |string|
  within 'form' do
    click_on string
  end
end

Then 'I see main page' do
  expect(page).to have_css(
    'h1',
    text: I18n.translate('home.show.primary_title'),
  )

  expect(page).to have_css(
    'h1 small',
    text: I18n.translate('home.show.secondary_title'),
  )
end

Given 'I want to create the following passport:' do |table|
  @passport_attributes = table.rows.to_h
end

When 'I fill the passport creation form' do
  fill_in 'Фамилия',           with: @passport_attributes['Фамилия']
  fill_in 'Имя',               with: @passport_attributes['Имя']
  fill_in 'Отчество',          with: @passport_attributes['Отчество']

  choose @passport_attributes['Пол']

  fill_in 'Место рождения',    with: @passport_attributes['Место рождения']
  fill_in 'Серия',             with: @passport_attributes['Серия']
  fill_in 'Номер',             with: @passport_attributes['Номер']
  fill_in 'Кем выдан',         with: @passport_attributes['Кем выдан']
  fill_in 'Код подразделения', with: @passport_attributes['Код подразделения']

  attach_file 'Изображение', 'fixtures/passport_image_1.jpg'
end

When 'I click the passport creation button' do
  click_on 'Создать Паспорт'
end

Then 'I see the passport page' do
  expect(page).to have_content @passport_attributes['Фамилия']
  expect(page).to have_content @passport_attributes['Имя']
  expect(page).to have_content @passport_attributes['Отчество']
  expect(page).to have_content @passport_attributes['Пол']
  expect(page).to have_content @passport_attributes['Место рождения']
  expect(page).to have_content @passport_attributes['Серия']
  expect(page).to have_content @passport_attributes['Номер']
  expect(page).to have_content @passport_attributes['Кем выдан']
  expect(page).to have_content @passport_attributes['Код подразделения']
end
