# frozen_string_literal: true

FactoryBot.define do
  factory :rsa_public_key do
    public_key_pem { OpenSSL::PKey::RSA.new(bits).public_key.to_pem }
    bits { [2048, 4096].sample }
    sha1 { Digest::SHA1.hexdigest SecureRandom.hex }
    sha256 { Digest::SHA256.hexdigest SecureRandom.hex }
  end
end
