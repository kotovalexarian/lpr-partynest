# frozen_string_literal: true

When 'I visit the main page' do
  visit '/'
end

Then 'I see the main page' do
  expect(page.current_path).to eq '/'
  expect(page).to have_css 'h1', text: 'Либертарианская партия России'
end
