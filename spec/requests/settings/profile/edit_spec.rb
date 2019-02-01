# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /settings/profile/edit' do
  before do
    sign_in current_account.user if current_account&.user
    get '/settings/profile/edit'
  end

  for_account_types nil do
    specify do
      expect(response).to have_http_status :unauthorized
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
