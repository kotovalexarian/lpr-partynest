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

  for_account_types nil do
    specify do
      expect(response).to have_http_status :forbidden
    end
  end

  xfor_account_types :guest do
    specify do
      expect(response).to have_http_status :ok
    end
  end

  for_account_types :usual, :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end
end
