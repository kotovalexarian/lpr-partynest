# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateX509SelfSignedCertificate do
  subject do
    described_class.call(
      asymmetric_key: asymmetric_key,
      distinguished_name: distinguished_name,
      not_before: not_before,
      not_after: not_after,
    )
  end

  let(:asymmetric_key) { CreateRSAKeys.call.asymmetric_key }
  let(:distinguished_name) { "CN=#{Faker::Internet.domain_name}" }
  let(:not_before) { Faker::Time.backward.utc }
  let(:not_after) { Faker::Time.forward.utc }

  specify do
    expect { subject }.to change(X509Certificate, :count).by(1)
  end

  specify do
    expect(subject.certificate).to be_instance_of X509Certificate
  end

  specify do
    expect(subject.certificate.asymmetric_key).to eq asymmetric_key
  end

  specify do
    expect(subject.certificate.pem).to \
      be_start_with "-----BEGIN CERTIFICATE-----\n"
  end

  specify do
    expect(subject.certificate.subject).to eq "/#{distinguished_name}"
  end

  specify do
    expect(subject.certificate.issuer).to eq "/#{distinguished_name}"
  end

  specify do
    expect(subject.certificate.not_before).to eq not_before
  end

  specify do
    expect(subject.certificate.not_after).to eq not_after
  end
end
