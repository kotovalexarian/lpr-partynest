# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateRSAKeysAndX509SelfSignedCertificate do
  subject do
    described_class.call(
      distinguished_name: distinguished_name,
      not_before: not_before,
      not_after: not_after,
    )
  end

  let(:distinguished_name) { "CN=#{Faker::Internet.domain_name}" }
  let(:not_before) { Faker::Time.backward.utc }
  let(:not_after) { Faker::Time.forward.utc }

  specify do
    expect { subject }.to change(RSAPublicKey, :count).by(1)
  end

  specify do
    expect { subject }.to change(X509Certificate, :count).by(1)
  end

  specify do
    expect(subject.private_key_pem).to be_instance_of String
  end

  specify do
    expect(subject.public_key).to be_instance_of RSAPublicKey
  end

  specify do
    expect(subject.certificate).to be_instance_of X509Certificate
  end
end
