# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateRSAKeys do
  subject { described_class.call }

  specify do
    expect { subject }.to change(RSAPublicKey, :count).by(1)
  end

  specify do
    expect(subject.private_key_pem).to be_instance_of String
  end

  specify do
    expect(subject.private_key_pem_key).to be_instance_of String
  end

  specify do
    expect(subject.public_key).to be_instance_of RSAPublicKey
  end

  specify do
    expect(subject.private_key_pem).to be_frozen
  end

  specify do
    expect(subject.private_key_pem_key).to be_frozen
  end

  specify do
    expect(subject.private_key_pem).not_to be_blank
  end

  specify do
    expect(subject.private_key_pem_key).not_to be_blank
  end

  specify do
    expect { OpenSSL::PKey::RSA.new subject.private_key_pem }.not_to raise_error
  end

  specify do
    expect { OpenSSL::PKey::RSA.new subject.public_key.pem }.not_to raise_error
  end

  specify do
    expect(subject.public_key.pem).to \
      eq OpenSSL::PKey::RSA.new(subject.private_key_pem).public_key.to_pem
  end

  specify do
    expect(subject.public_key.private_key_pem_iv).not_to be_blank
  end

  specify do
    expect(subject.public_key.private_key_pem_ciphertext).not_to be_blank
  end

  specify do
    cipher = OpenSSL::Cipher::AES256.new
    cipher.decrypt
    cipher.iv = subject.public_key.private_key_pem_iv
    cipher.key = subject.private_key_pem_key

    cleartext = [
      cipher.update(subject.public_key.private_key_pem_ciphertext),
      cipher.final,
    ].join.freeze

    expect(cleartext).to eq subject.private_key_pem
  end
end
