# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/people/:person_id/account_connection_link' do
  let(:person) { create :initial_person }

  let(:current_account) { create :superuser_account }

  before do
    sign_in current_account.user if current_account&.user

    get "/staff/people/#{person.to_param}/account_connection_link"
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

  context 'when person already has account' do
    let(:person) { create(:personal_account).person }

    specify do
      expect(response).to have_http_status :ok
    end
  end
end
