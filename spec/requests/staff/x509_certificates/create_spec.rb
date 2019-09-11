# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /staff/x509_certificates' do
  let(:current_account) { create :superuser_account }

  let :x509_certificate_form_attributes do
    {
      distinguished_name: distinguished_name,
      not_before: not_before,
      not_after: not_after,
    }
  end

  let :x509_certificate_attributes do
    {
      subject: distinguished_name,
      issuer: distinguished_name,
      not_before: not_before,
      not_after: not_after,
    }
  end

  let(:distinguished_name) { "/CN=#{Faker::Internet.domain_name}" }
  let(:not_before) { Faker::Time.backward.utc }
  let(:not_after) { Faker::Time.forward.utc }

  def make_request
    post '/staff/x509_certificates',
         params: { x509_certificate: x509_certificate_form_attributes }
  end

  before do
    sign_in current_account.user if current_account&.user
  end

  for_account_types nil, :usual do
    specify do
      expect { make_request }.not_to change(X509Certificate, :count)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to have_http_status :forbidden
      end
    end
  end

  for_account_types :superuser do
    specify do
      expect { make_request }.to change(X509Certificate, :count).by(1)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to redirect_to [:staff, X509Certificate.last]
      end

      specify do
        expect(X509Certificate.last).to \
          have_attributes x509_certificate_attributes
      end
    end
  end

  context 'when distinguished name is missing' do
    let(:distinguished_name) { nil }

    specify do
      expect { make_request }.not_to change(X509Certificate, :count)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to have_http_status :ok
      end
    end
  end

  context 'when activation time is missing' do
    let(:not_before) { nil }

    specify do
      expect { make_request }.not_to change(X509Certificate, :count)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to have_http_status :ok
      end
    end
  end

  context 'when expiration time is missing' do
    let(:not_after) { nil }

    specify do
      expect { make_request }.not_to change(X509Certificate, :count)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to have_http_status :ok
      end
    end
  end

  context 'when distinguished name is invalid' do
    let(:distinguished_name) { 'Hello!' }

    specify do
      expect { make_request }.not_to change(X509Certificate, :count)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to have_http_status :ok
      end
    end
  end
end
