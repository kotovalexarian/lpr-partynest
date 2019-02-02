# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/telegram_bots/:id' do
  let!(:telegram_bot) { create :telegram_bot }

  before do
    sign_in current_account.user if current_account&.user
    get "/staff/telegram_bots/#{telegram_bot.id}"
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
