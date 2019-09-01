# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/accounts' do
  before do
    sign_in current_account.user if current_account&.user

    create :usual_account
    create :personal_account
    create :superuser_account

    get '/staff/accounts'
  end

  for_account_types nil, :usual do
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
