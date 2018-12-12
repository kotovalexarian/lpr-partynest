# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /settings/telegram_contacts' do
  before do
    sign_in current_account.user if current_account&.user

    if current_account
      create_list :account_telegram_contact, 5, account: current_account
    end

    get '/settings/telegram_contacts'
  end

  context 'when no account is authenticated' do
    let(:current_account) { nil }

    specify do
      expect(response).to have_http_status :unauthorized
    end
  end

  xcontext 'when guest account is authenticated' do
    let(:current_account) { create :guest_account }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when usual account is authenticated' do
    let(:current_account) { create :usual_account }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when superuser account is authenticated' do
    let(:current_account) { create :superuser_account }

    specify do
      expect(response).to have_http_status :ok
    end
  end
end
