# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /settings/passports/:id' do
  let(:current_account) { create :superuser_account }

  let(:person) { current_account&.person || create(:initial_person) }
  let(:passport) { create :empty_passport, person: person }

  before do
    sign_in current_account.user if current_account&.user

    get "/settings/passports/#{passport.to_param}"
  end

  for_account_types nil, :usual do
    specify do
      expect(response).to have_http_status :forbidden
    end
  end

  for_account_types :personal, :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when person is not linked to current account' do
    let(:person) { create :initial_person }

    specify do
      expect(response).to have_http_status :forbidden
    end
  end
end
