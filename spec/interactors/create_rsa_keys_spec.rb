# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateRSAKeys do
  subject { described_class.call account: account }

  let(:account) { create :initial_account }

  specify do
    expect { subject }.to change(AsymmetricKey, :count).by(1)
  end

  specify do
    expect { subject }.to change(RSAKey, :count).by(1)
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
    expect(subject.asymmetric_key.sha1).not_to be_blank
  end

  specify do
    expect(subject.asymmetric_key.sha256).not_to be_blank
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

  specify do
    expect do
      OpenSSL::PKey::RSA.new subject.asymmetric_key.private_key_pem
    end.not_to raise_error
  end

  specify do
    expect do
      OpenSSL::PKey::RSA.new subject.asymmetric_key.public_key_pem
    end.not_to \
      raise_error
  end

  specify do
    expect(subject.asymmetric_key.sha1).to eq(
      Digest::SHA1.hexdigest(
        OpenSSL::PKey::RSA.new(subject.asymmetric_key.public_key_pem).to_der,
      ),
    )
  end

  specify do
    expect(subject.asymmetric_key.sha256).to eq(
      Digest::SHA256.hexdigest(
        OpenSSL::PKey::RSA.new(subject.asymmetric_key.public_key_pem).to_der,
      ),
    )
  end

  specify do
    expect(subject.asymmetric_key.public_key_pem).to eq(
      OpenSSL::PKey::RSA.new(subject.asymmetric_key.private_key_pem)
                        .public_key.to_pem,
    )
  end

  specify do
    expect(subject.asymmetric_key.private_key_pem_iv).not_to be_blank
  end

  specify do
    expect(subject.asymmetric_key.private_key_pem_ciphertext).not_to be_blank
  end

  specify do
    cipher = OpenSSL::Cipher::AES256.new
    cipher.decrypt
    cipher.iv  = subject.asymmetric_key.private_key_pem_iv
    cipher.key = subject.asymmetric_key.private_key_pem_secret

    cleartext = [
      cipher.update(subject.asymmetric_key.private_key_pem_ciphertext),
      cipher.final,
    ].join.freeze

    expect(cleartext).to eq subject.asymmetric_key.private_key_pem
  end

  context 'when owner is not specified' do
    let(:account) { nil }

    specify do
      expect(subject.asymmetric_key.account).to equal nil
    end
  end
end
