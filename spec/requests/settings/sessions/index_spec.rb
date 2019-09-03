# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /settings/sessions' do
  before do
    sign_in current_account.user if current_account&.user

    if current_account
      create_list :some_session, rand(1..3), account: current_account
    end

    get '/settings/sessions'
  end

  for_account_types nil do
    specify do
      expect(response).to have_http_status :forbidden
    end
  end

  for_account_types :usual, :personal, :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end
end
