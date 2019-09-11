# frozen_string_literal: true

require 'rails_helper'

RSpec.describe X509Certificate do
  subject { create :self_signed_x509_certificate }

  describe '#x509_certificate_request' do
    it { is_expected.not_to validate_presence_of :x509_certificate_request }
  end

  describe '#pem' do
    def allow_value(*)
      super.for :pem
    end

    it { is_expected.to validate_presence_of :pem }

    it 'is allowed to be a valid certificate' do
      is_expected.to allow_value File.read Rails.root.join 'fixtures', 'ca.crt'
    end

    it 'is not allowed to be an invalid certificate' do
      is_expected.not_to allow_value OpenSSL::X509::Certificate.new.to_pem
    end
  end

  describe '#subject' do
    it { is_expected.to validate_presence_of :subject }
  end

  describe '#issuer' do
    it { is_expected.to validate_presence_of :issuer }
  end

  describe '#not_before' do
    it { is_expected.to validate_presence_of :not_before }
  end

  describe '#not_after' do
    it { is_expected.to validate_presence_of :not_after }
  end
end
