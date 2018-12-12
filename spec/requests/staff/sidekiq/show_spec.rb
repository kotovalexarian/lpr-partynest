# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/sidekiq' do
  before do
    @new_user_session_url = new_user_session_url
    sign_in current_account.user if current_account&.user
    get '/staff/sidekiq'
  end

  context 'when no account is authenticated' do
    let(:current_account) { nil }

    specify do
      expect(response).to redirect_to @new_user_session_url
    end
  end

  context 'when guest account is authenticated' do
    let(:current_account) { create :guest_account }

    specify do
      expect(response).to redirect_to @new_user_session_url
    end
  end

  context 'when usual account is authenticated' do
    let(:current_account) { create :usual_account }

    specify do
      expect(response).to redirect_to root_url
    end
  end

  context 'when superuser account is authenticated' do
    let(:current_account) { create :superuser_account }

    specify do
      expect(response).to have_http_status :ok
    end
  end
end
