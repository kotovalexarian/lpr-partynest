# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/people/:person_id/passports/:id' do
  let(:person) { create :initial_person }
  let(:passport) { create :empty_passport, person: person }

  before do
    sign_in current_account.user if current_account&.user

    get "/staff/people/#{person.to_param}/passports/#{passport.to_param}"
  end

  for_account_types nil, :usual do
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
