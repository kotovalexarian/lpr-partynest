# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateX509CertificateRequest do
  subject do
    described_class.call(
      public_key: public_key,
      distinguished_name: distinguished_name,
    )
  end

  let(:rsa_keys) { CreateRSAKeys.call }
  let(:public_key) { rsa_keys.public_key }
  let(:distinguished_name) { "CN=#{Faker::Internet.domain_name}" }

  specify do
    expect { subject }.to change(X509CertificateRequest, :count).by(1)
  end

  specify do
    expect(subject.certificate_request).to be_instance_of X509CertificateRequest
  end

  specify do
    expect(subject.certificate_request.rsa_public_key).to eq public_key
  end

  specify do
    expect(subject.certificate_request.distinguished_name).to \
      eq distinguished_name
  end

  specify do
    expect(subject.certificate_request.pem).to \
      be_start_with "-----BEGIN CERTIFICATE REQUEST-----\n"
  end
end
