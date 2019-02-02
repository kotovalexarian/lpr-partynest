# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /settings/roles' do
  before do
    sign_in current_account.user if current_account&.user
    get '/settings/roles'
  end

  for_account_types nil, :guest do
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
