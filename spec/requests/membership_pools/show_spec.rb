# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /membership_pools/:id' do
  let!(:membership_pool) { create :membership_pool }

  def make_request
    get "/membership_pools/#{membership_pool.id}"
  end

  before do
    sign_in current_account.user if current_account&.user
    make_request
  end

  context 'when no account is authenticated' do
    let(:current_account) { nil }

    specify do
      expect(response).to have_http_status :unauthorized
    end
  end

  context 'when guest account is authenticated' do
    let(:current_account) { create :guest_account }

    specify do
      expect(response).to have_http_status :unauthorized
    end
  end

  context 'when usual account is authenticated' do
    let(:current_account) { create :account_with_user }

    specify do
      expect(response).to have_http_status :unauthorized
    end
  end

  context 'when superuser account is authenticated' do
    let(:current_account) { create :superuser_account }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when authorized account is authenticated' do
    let :current_account do
      create :account_with_user, membership_pools: [membership_pool]
    end

    specify do
      expect(response).to have_http_status :ok
    end
  end
end
