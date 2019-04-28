# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PATCH/PUT /settings/profile' do
  let(:current_account) { create :personal_account }

  let :account_attributes do
    {
      nickname: Faker::Internet.username(3..36, %w[_]),
      public_name: Faker::Name.name,
      biography: Faker::Lorem.paragraph,
    }
  end

  before do
    sign_in current_account.user if current_account&.user
  end

  def make_request
    patch '/settings/profile', params: { account: account_attributes }
  end

  for_account_types nil, :guest do
    before { make_request }

    specify do
      expect(response).to have_http_status :forbidden
    end
  end

  for_account_types :usual, :superuser do
    specify do
      expect { make_request }.to \
        change { current_account.reload.nickname }
        .from(current_account.nickname)
        .to(account_attributes[:nickname])
    end

    specify do
      expect { make_request }.to \
        change { current_account.reload.public_name }
        .from(current_account.public_name)
        .to(account_attributes[:public_name])
    end

    specify do
      expect { make_request }.to \
        change { current_account.reload.biography }
        .from(current_account.biography)
        .to(account_attributes[:biography])
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to redirect_to edit_settings_profile_url
      end
    end
  end
end
