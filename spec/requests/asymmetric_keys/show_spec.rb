# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /asymmetric_keys/:id' do
  let(:current_account) { nil }

  let(:asymmetric_key) { create %i[rsa_key ecurve_key].sample }

  def make_request
    get "/asymmetric_keys/#{asymmetric_key.id}"
  end

  before do
    sign_in current_account.user if current_account&.user
    make_request
  end

  for_account_types nil, :usual, :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'for RSA key' do
    let(:asymmetric_key) { create :rsa_key }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'for elliptic-curve key' do
    let(:asymmetric_key) { create :ecurve_key }

    specify do
      expect(response).to have_http_status :ok
    end
  end
end
