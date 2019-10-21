# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /staff/people/:person_id/account_connection_link' do
  let :person do
    create(:initial_person).tap(&:generate_account_connection_token)
  end

  let(:current_account) { create :superuser_account }

  def make_request
    delete "/staff/people/#{person.to_param}/account_connection_link"
  end

  before do
    sign_in current_account.user if current_account&.user
  end

  for_account_types nil, :usual do
    before { make_request }

    specify do
      expect(response).to have_http_status :forbidden
    end
  end

  for_account_types :superuser do
    specify do
      expect { make_request }.to(
        change { person.reload.account_connection_token }.to(nil),
      )
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to \
          redirect_to "/staff/people/#{person.to_param}/account_connection_link"
      end
    end
  end

  context 'when person already has account' do
    let(:person) { create(:personal_account).person }

    specify do
      expect { make_request }.not_to(
        change { person.reload.account_connection_token },
      )
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to have_http_status :forbidden
      end
    end
  end
end
