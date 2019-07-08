# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/passports' do
  before do
    create :empty_passport
    create :passport_with_map
    create :passport_with_image
    create :passport_with_map_and_image
    create :passport_with_almost_enough_confirmations
    create :passport_with_enough_confirmations
    create :confirmed_passport

    get '/staff/passports'
  end

  specify do
    expect(response).to have_http_status :ok
  end
end
