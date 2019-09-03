# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PATCH/PUT /settings/appearance' do
  let(:current_account) { create :usual_account }

  let :account_attributes do
    {
      timezone: timezone,
    }
  end

  let :timezone do
    timezone = "#{[nil, :-].sample}#{rand(1..11).to_s.rjust(2, '0')}:00:00"

    if timezone != current_account&.timezone
      timezone
    elsif current_account&.timezone == '02:00:00'
      '05:00:00'
    else
      '02:00:00'
    end
  end

  before do
    sign_in current_account.user if current_account&.user
  end

  def make_request
    patch '/settings/appearance', params: { account: account_attributes }
  end

  for_account_types nil do
    before { make_request }

    specify do
      expect(response).to have_http_status :forbidden
    end
  end

  for_account_types :usual, :personal, :superuser do
    specify do
      expect { make_request }.to \
        change { current_account.reload.timezone }
        .from(current_account.timezone)
        .to(account_attributes[:timezone])
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to redirect_to edit_settings_appearance_url
      end
    end
  end
end
