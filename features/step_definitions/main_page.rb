# frozen_string_literal: true

When 'I visit the main page' do
  visit '/'
end

Then 'I see the main page' do
  expect(page.current_path).to eq '/'
  expect(page).to have_css 'h1', text: 'Либертарианская партия России'
end

Then 'I see the join button' do
  expect(page).to have_link 'Вступить'
end

Then 'I do not see the join button' do
  expect(page).not_to have_link 'Вступить'
end

When 'I click the join button' do
  click_on 'Вступить'
end

Then 'I see the membership application button' do
  expect(page).to have_link 'Ваше заявление'
end

Then 'I do not see the membership application button' do
  expect(page).not_to have_link 'Ваше заявление'
end

When 'I click the membership application button' do
  click_on 'Ваше заявление'
end
