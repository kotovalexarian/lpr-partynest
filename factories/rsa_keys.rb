# frozen_string_literal: true

FactoryBot.define do
  factory :rsa_key do
    association :account, factory: :usual_account

    public_key_pem { OpenSSL::PKey::RSA.new(bits).public_key.to_pem }
    public_key_der { OpenSSL::PKey::RSA.new(bits).public_key.to_der }
    bits { [2048, 4096].sample }
    sha1 { Digest::SHA1.hexdigest SecureRandom.hex }
    sha256 { Digest::SHA256.hexdigest SecureRandom.hex }
  end
end
