# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/sidekiq' do
  before do
    @new_user_session_url = new_user_session_url
    sign_in current_account.user if current_account&.user
    get '/staff/sidekiq'
  end

  for_account_types nil, :guest do
    specify do
      expect(response).to redirect_to @new_user_session_url
    end
  end

  for_account_types :usual do
    specify do
      expect(response).to redirect_to root_url
    end
  end

  for_account_types :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end
end
