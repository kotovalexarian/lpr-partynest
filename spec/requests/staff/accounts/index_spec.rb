# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/accounts' do
  let(:current_account) { create :superuser_account }

  let :accounts_count do
    [0, 1, rand(2..4), rand(5..10), rand(20..40)].sample
  end

  before do
    sign_in current_account.user if current_account&.user

    create_list :personal_account, accounts_count

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

  context 'when there are no accounts' do
    let(:accounts_count) { 0 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there is one account' do
    let(:accounts_count) { 1 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are few accounts' do
    let(:accounts_count) { rand 2..4 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are many accounts' do
    let(:accounts_count) { rand 5..10 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are lot of accounts' do
    let(:accounts_count) { rand 20..40 }

    specify do
      expect(response).to have_http_status :ok
    end
  end
end
