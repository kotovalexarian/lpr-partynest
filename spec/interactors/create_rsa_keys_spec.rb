# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateRSAKeys do
  subject { described_class.call }

  specify do
    expect { subject }.to change(RSAKey, :count).by(1)
  end

  specify do
    expect { subject }.to(
      have_enqueued_job(ClearRSAPrivateKeyJob)
      .with do |rsa_key_id|
        expect(rsa_key_id).to equal RSAKey.last.id
      end,
    )
  end

  specify do
    expect(subject.key).to be_instance_of RSAKey
  end

  specify do
    expect(subject.key.sha1).not_to be_blank
  end

  specify do
    expect(subject.key.sha256).not_to be_blank
  end

  specify do
    expect(subject.key.private_key_pem).not_to be_blank
  end

  specify do
    expect(subject.key.private_key_pem_secret).not_to be_blank
  end

  specify do
    expect do
      OpenSSL::PKey::RSA.new subject.key.private_key_pem
    end.not_to raise_error
  end

  specify do
    expect { OpenSSL::PKey::RSA.new subject.key.public_key_pem }.not_to \
      raise_error
  end

  specify do
    expect(subject.key.sha1).to eq(
      Digest::SHA1.hexdigest(
        OpenSSL::PKey::RSA.new(subject.key.public_key_pem).to_der,
      ),
    )
  end

  specify do
    expect(subject.key.sha256).to eq(
      Digest::SHA256.hexdigest(
        OpenSSL::PKey::RSA.new(subject.key.public_key_pem).to_der,
      ),
    )
  end

  specify do
    expect(subject.key.public_key_pem).to eq(
      OpenSSL::PKey::RSA.new(subject.key.private_key_pem)
                        .public_key.to_pem,
    )
  end

  specify do
    expect(subject.key.private_key_pem_iv).not_to be_blank
  end

  specify do
    expect(subject.key.private_key_pem_ciphertext).not_to be_blank
  end

  specify do
    cipher = OpenSSL::Cipher::AES256.new
    cipher.decrypt
    cipher.iv  = subject.key.private_key_pem_iv
    cipher.key = subject.key.private_key_pem_secret

    cleartext = [
      cipher.update(subject.key.private_key_pem_ciphertext),
      cipher.final,
    ].join.freeze

    expect(cleartext).to eq subject.key.private_key_pem
  end
end
