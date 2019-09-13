# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RSAKey do
  subject { create :rsa_key }

  it_behaves_like 'asymmetric_key'

  describe '#bits' do
    it { is_expected.to validate_inclusion_of(:bits).in_array([2048, 4096]) }
  end

  describe '#encrypt_private_key_pem' do
    subject { create :rsa_key, private_key_pem: cleartext }

    let(:cleartext) { OpenSSL::PKey::RSA.new.to_pem.freeze }

    specify do
      expect(subject.encrypt_private_key_pem).to be_instance_of String
    end

    specify do
      expect(subject.encrypt_private_key_pem).to be_frozen
    end

    specify do
      expect(subject.encrypt_private_key_pem).to \
        equal subject.private_key_pem_secret
    end

    specify do
      expect { subject.encrypt_private_key_pem }.to \
        change(subject, :private_key_pem_iv)
        .from(nil)
    end

    specify do
      expect { subject.encrypt_private_key_pem }.to \
        change(subject, :private_key_pem_secret)
        .from(nil)
    end

    specify do
      expect { subject.encrypt_private_key_pem }.to \
        change(subject, :private_key_pem_ciphertext)
        .from(nil)
    end

    context 'after call' do
      before { subject.encrypt_private_key_pem }

      specify do
        expect(subject.private_key_pem).to be_instance_of String
      end

      specify do
        expect(subject.private_key_pem_iv).to be_instance_of String
      end

      specify do
        expect(subject.private_key_pem_secret).to be_instance_of String
      end

      specify do
        expect(subject.private_key_pem_ciphertext).to be_instance_of String
      end

      specify do
        expect(subject.private_key_pem).to be_frozen
      end

      specify do
        expect(subject.private_key_pem_iv).to be_frozen
      end

      specify do
        expect(subject.private_key_pem_secret).to be_frozen
      end

      specify do
        expect(subject.private_key_pem_ciphertext).to be_frozen
      end

      specify do
        expect(subject.private_key_pem).to eq cleartext
      end

      specify do
        expect(subject.private_key_pem_iv).not_to be_blank
      end

      specify do
        expect(subject.private_key_pem_secret).not_to be_blank
      end

      specify do
        expect(subject.private_key_pem_ciphertext).not_to be_blank
      end

      specify do
        cipher = OpenSSL::Cipher::AES256.new
        cipher.encrypt

        cipher.iv  = subject.private_key_pem_iv
        cipher.key = subject.private_key_pem_secret

        ciphertext = [
          cipher.update(cleartext),
          cipher.final,
        ].join.freeze

        expect(subject.private_key_pem_ciphertext).to eq ciphertext
      end
    end
  end

  describe '#decrypt_private_key_pem' do
    subject do
      create(
        :rsa_key,
        private_key_pem_iv: iv,
        private_key_pem_secret: secret,
        private_key_pem_ciphertext: ciphertext,
      )
    end

    let(:cleartext) { OpenSSL::PKey::RSA.new.to_pem.freeze }

    let!(:cipher) { OpenSSL::Cipher::AES256.new.tap(&:encrypt) }

    let!(:iv)     { cipher.random_iv.freeze }
    let!(:secret) { cipher.random_key.freeze }

    let!(:ciphertext) { [cipher.update(cleartext), cipher.final].join.freeze }

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

    context 'after call' do
      before { subject.decrypt_private_key_pem }

      specify do
        expect(subject.private_key_pem).to be_instance_of String
      end

      specify do
        expect(subject.private_key_pem_iv).to be_instance_of String
      end

      specify do
        expect(subject.private_key_pem_secret).to be_instance_of String
      end

      specify do
        expect(subject.private_key_pem_ciphertext).to be_instance_of String
      end

      specify do
        expect(subject.private_key_pem).to be_frozen
      end

      specify do
        expect(subject.private_key_pem_iv).to be_frozen
      end

      specify do
        expect(subject.private_key_pem_secret).to be_frozen
      end

      specify do
        expect(subject.private_key_pem_ciphertext).to be_frozen
      end

      specify do
        expect(subject.private_key_pem).to eq cleartext
      end

      specify do
        expect(subject.private_key_pem_iv).to equal iv
      end

      specify do
        expect(subject.private_key_pem_secret).to equal secret
      end

      specify do
        expect(subject.private_key_pem_ciphertext).to equal ciphertext
      end
    end
  end
end
