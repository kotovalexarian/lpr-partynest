# frozen_string_literal: true

When 'I visit {string}' do |string|
  visit string
end

Then 'I am at {string}' do |re|
  expect(page.current_path).to match(/\A#{re}\z/)
end

When 'I fill form with the following data:' do |table|
  within 'form' do
    table.rows.each do |(key, value)|
      fill_in key, with: value, match: :prefer_exact
    end
  end
end

When 'I upload {string} as {string}' do |fixture, field|
  within 'form' do
    attach_file field, Rails.root.join('fixtures', fixture)
  end
end

When 'I click {string}' do |string|
  click_on string
end

When 'I click first {string}' do |string|
  click_on string, match: :first
end

When 'I click the button {string}' do |string|
  click_on string
end

When 'I click the form button {string}' do |string|
  within 'form' do
    click_on string
  end
end

When 'I click font awesome {string}' do |string|
  all("i.fa-#{string}").sample.ancestor(:xpath, './/a').click
end

Then 'I see text {string}' do |text|
  expect(page).to have_content text
end

Then 'I do not see text {string}' do |text|
  expect(page).not_to have_content text
end

Then 'I see CSS {string} with text {string}' do |selector, text|
  expect(page).to have_css selector, text: text
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

  attach_file 'Изображения', Rails.root.join('fixtures', 'passport_image_1.jpg')
end

When 'I click the passport creation button' do
  click_on 'Создать Паспорт'
end

Then 'I see the passport page' do
  @passport_attributes.each do |key, value|
    case key
    when 'Пол'
      nil
    when 'Серия', 'Номер'
      expect(page).to have_field key, with: value.to_i
    else
      expect(page).to have_field key, with: value if value.present?
    end
  end
end
