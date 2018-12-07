# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /telegram_bots/:id' do
  let!(:telegram_bot) { create :telegram_bot }

  before do
    sign_in current_account.user if current_account&.user
    get "/telegram_bots/#{telegram_bot.id}"
  end

  context 'when no account is authenticated' do
    let(:current_account) { nil }

    specify do
      expect(response).to have_http_status :unauthorized
    end
  end

  context 'when guest account is authenticated' do
    let(:current_account) { create :guest_account }

    specify do
      expect(response).to have_http_status :unauthorized
    end
  end

  context 'when usual account is authenticated' do
    let(:current_account) { create :account_with_user }

    specify do
      expect(response).to have_http_status :unauthorized
    end
  end

  context 'when superuser account is authenticated' do
    let(:current_account) { create :superuser_account }

    specify do
      expect(response).to have_http_status :ok
    end
  end
end
