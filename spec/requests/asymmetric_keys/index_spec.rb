# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /asymmetric_keys' do
  let(:current_account) { create :superuser_account }

  let :asymmetric_keys_count do
    [0, 1, rand(2..4), rand(5..10), rand(20..40)].sample
  end

  let(:rsa_keys_count) { rand(1...asymmetric_keys_count) || 0 }
  let(:ecurve_keys_count) { asymmetric_keys_count - rsa_keys_count }

  before do
    sign_in current_account.user if current_account&.user

    create_list :rsa_key,    rsa_keys_count
    create_list :ecurve_key, ecurve_keys_count

    get '/asymmetric_keys'
  end

  for_account_types nil, :usual, :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are no asymmetric keys' do
    let(:asymmetric_keys_count) { 0 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there is one asymmetric key' do
    let(:asymmetric_keys_count) { 1 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are few asymmetric keys' do
    let(:asymmetric_keys_count) { rand 2..4 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are many asymmetric keys' do
    let(:asymmetric_keys_count) { rand 5..10 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are lot of asymmetric keys' do
    let(:asymmetric_keys_count) { rand 20..40 }

    specify do
      expect(response).to have_http_status :ok
    end
  end
end
