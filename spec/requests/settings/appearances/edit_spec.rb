# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /settings/appearance/edit' do
  before do
    sign_in current_account.user if current_account&.user
    get '/settings/appearance/edit'
  end

  for_account_types nil do
    specify do
      expect(response).to have_http_status :forbidden
    end
  end

  for_account_types :usual, :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end
end
