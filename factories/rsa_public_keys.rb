# frozen_string_literal: true

FactoryBot.define do
  factory :rsa_public_key do
    pem { OpenSSL::PKey::RSA.new(bits).public_key.to_pem }
    bits { [2048, 4096].sample }
  end
end
