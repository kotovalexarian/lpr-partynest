# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSAPublicKey do
  subject { create :rsa_public_key }

  describe '#public_key_pem' do
    it { is_expected.to validate_presence_of :public_key_pem }
  end

  describe '#bits' do
    it { is_expected.to validate_inclusion_of(:bits).in_array([2048, 4096]) }
  end

  describe '#private_key_pem_iv' do
    it { is_expected.not_to validate_presence_of :private_key_pem_iv }
  end

  describe '#private_key_pem_ciphertext' do
    it { is_expected.not_to validate_presence_of :private_key_pem_ciphertext }
  end

  describe '#decrypt_private_key_pem' do
    let(:cleartext) { OpenSSL::PKey::RSA.new.to_pem }

    before do
      cipher = OpenSSL::Cipher::AES256.new
      cipher.encrypt

      subject.private_key_pem_iv     = cipher.random_iv
      subject.private_key_pem_secret = cipher.random_key

      subject.private_key_pem_ciphertext = [
        cipher.update(cleartext),
        cipher.final,
      ].join
    end

    specify do
      expect(subject.decrypt_private_key_pem).to be_instance_of String
    end

    specify do
      expect(subject.decrypt_private_key_pem).to be_frozen
    end

    specify do
      expect(subject.decrypt_private_key_pem).to equal subject.private_key_pem
    end

    specify do
      expect { subject.decrypt_private_key_pem }.to \
        change(subject, :private_key_pem)
        .from(nil)
        .to(cleartext)
    end
  end
end
