# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/x509_certificates' do
  let(:current_account) { create :superuser_account }

  let :x509_certificates_count do
    [0, 1, rand(2..4), rand(5..10), rand(20..100)].sample
  end

  before do
    sign_in current_account.user if current_account&.user

    create_list :self_signed_x509_certificate, x509_certificates_count

    get '/staff/x509_certificates'
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

  context 'when there are no X509 certificates' do
    let(:x509_certificates_count) { 0 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there is one X509 certificate' do
    let(:x509_certificates_count) { 1 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are few X509 certificates' do
    let(:x509_certificates_count) { rand 2..4 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are many X509 certificates' do
    let(:x509_certificates_count) { rand 5..10 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are lot of X509 certificates' do
    let(:x509_certificates_count) { rand 20..100 }

    specify do
      expect(response).to have_http_status :ok
    end
  end
end
