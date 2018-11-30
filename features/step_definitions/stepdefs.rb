# frozen_string_literal: true

When 'I visit main page' do
  visit '/'
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
