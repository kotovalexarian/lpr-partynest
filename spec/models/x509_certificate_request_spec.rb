# frozen_string_literal: true

require 'rails_helper'

RSpec.describe X509CertificateRequest do
  subject { create :x509_certificate_request }

  describe '#rsa_public_key' do
    it do
      is_expected.to \
        validate_presence_of(:rsa_public_key).with_message(:required)
    end
  end

  describe '#distinguished_name' do
    it { is_expected.to validate_presence_of :distinguished_name }

    it do
      is_expected.to validate_length_of(:distinguished_name).is_at_most(10_000)
    end
  end

  describe '#pem' do
    it { is_expected.to validate_presence_of :pem }
  end
end
