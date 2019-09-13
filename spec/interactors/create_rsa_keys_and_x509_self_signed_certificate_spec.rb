# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateRSAKeysAndX509SelfSignedCertificate do
  subject do
    described_class.call(
      account: account,
      distinguished_name: distinguished_name,
      not_before: not_before,
      not_after: not_after,
    )
  end

  let(:account) { create :initial_account }
  let(:distinguished_name) { "CN=#{Faker::Internet.domain_name}" }
  let(:not_before) { Faker::Time.backward.utc }
  let(:not_after) { Faker::Time.forward.utc }

  specify do
    expect { subject }.to change(AsymmetricKey, :count).by(1)
  end

  specify do
    expect { subject }.to change(RSAKey, :count).by(1)
  end

  specify do
    expect { subject }.to change(X509Certificate, :count).by(1)
  end

  specify do
    expect { subject }.to(
      have_enqueued_job(ClearAsymmetricPrivateKeyJob)
      .with do |asymmetric_key_id|
        expect(asymmetric_key_id).to equal AsymmetricKey.last.id
      end,
    )
  end

  specify do
    expect(subject.asymmetric_key).to be_instance_of RSAKey
  end

  specify do
    expect(subject.certificate).to be_instance_of X509Certificate
  end

  specify do
    expect(subject.asymmetric_key.private_key_pem).not_to be_blank
  end

  specify do
    expect(subject.asymmetric_key.private_key_pem_secret).not_to be_blank
  end

  specify do
    expect(subject.asymmetric_key.account).to eq account
  end

  context 'when owner is not specified' do
    let(:account) { nil }

    specify do
      expect(subject.asymmetric_key.account).to equal nil
    end
  end
end
