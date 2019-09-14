# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateEcurveKeys do
  subject { described_class.call account: account, password: password }

  let(:account) { create :initial_account }
  let(:password) { Faker::Internet.password }

  specify do
    expect { subject }.to change(AsymmetricKey, :count).by(1)
  end

  specify do
    expect { subject }.to change(EcurveKey, :count).by(1)
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
    expect(subject.asymmetric_key).to be_instance_of EcurveKey
  end

  specify do
    expect(subject.asymmetric_key.has_password).to equal true
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
      OpenSSL::PKey::EC.new(
        subject.asymmetric_key.private_key_pem,
        String(password),
      )
    end.not_to raise_error
  end

  specify do
    expect do
      OpenSSL::PKey::EC.new(
        subject.asymmetric_key.public_key_pem,
        String(password),
      )
    end.not_to raise_error
  end

  specify do
    expect(subject.asymmetric_key.sha1).to eq(
      Digest::SHA1.hexdigest(
        OpenSSL::PKey::EC.new(
          subject.asymmetric_key.public_key_pem,
          String(password),
        ).to_der,
      ),
    )
  end

  specify do
    expect(subject.asymmetric_key.sha256).to eq(
      Digest::SHA256.hexdigest(
        OpenSSL::PKey::EC.new(
          subject.asymmetric_key.public_key_pem,
          String(password),
        ).to_der,
      ),
    )
  end

  specify do
    private_key = OpenSSL::PKey::EC.new(
      subject.asymmetric_key.private_key_pem,
      String(password),
    )

    public_key = OpenSSL::PKey::EC.new private_key.public_key.group
    public_key.public_key = private_key.public_key

    expect(subject.asymmetric_key.public_key_pem).to eq public_key.to_pem
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

  context 'when password is nil' do
    let(:password) { nil }

    specify do
      expect(subject.asymmetric_key.has_password).to equal false
    end
  end

  context 'when password is blank' do
    let(:password) { ' ' * rand(1..3) }

    specify do
      expect(subject.asymmetric_key.has_password).to equal false
    end
  end

  context 'when password.to_s returns nil' do
    let :password do
      Class.new do
        def to_s
          nil
        end
      end.new
    end

    specify do
      expect { subject }.to raise_error TypeError
    end
  end
end
