# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/people/:person_id/resident_registrations' do
  let(:person) { create :initial_person }

  before do
    sign_in current_account.user if current_account&.user

    create :empty_resident_registration, person: person
    create :empty_resident_registration, person: person
    create :empty_resident_registration, person: person

    get "/staff/people/#{person.to_param}/resident_registrations"
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
