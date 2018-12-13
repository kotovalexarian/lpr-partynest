# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/telegram_chats/:id' do
  let!(:telegram_chat) { create :telegram_chat }

  before do
    sign_in current_account.user if current_account&.user
    get "/staff/telegram_chats/#{telegram_chat.id}"
  end

  for_account_types nil, :guest, :usual do
    specify do
      expect(response).to have_http_status :unauthorized
    end
  end

  for_account_types :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end
end
