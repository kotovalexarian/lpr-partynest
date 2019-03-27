# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/people/:person_id/passports' do
  let(:person) { create :initial_person }

  before do
    sign_in current_account.user if current_account&.user

    create :empty_passport,                            person: person
    create :passport_with_passport_map,                person: person
    create :passport_with_image,                       person: person
    create :passport_with_passport_map_and_image,      person: person
    create :passport_with_almost_enough_confirmations, person: person
    create :passport_with_enough_confirmations,        person: person
    create :confirmed_passport,                        person: person

    get "/staff/people/#{person.to_param}/passports"
  end

  for_account_types nil, :guest, :usual do
    specify do
      expect(response).to have_http_status :forbidden
    end
  end

  for_account_types :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end
end
