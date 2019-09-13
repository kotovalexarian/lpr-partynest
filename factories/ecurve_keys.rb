# frozen_string_literal: true

FactoryBot.define do
  factory :ecurve_key do
    association :account, factory: :usual_account

    public_key_pem do
      point = OpenSSL::PKey::EC.generate(curve).public_key
      pkey = OpenSSL::PKey::EC.new point.group
      pkey.public_key = point
      pkey.to_pem
    end

    public_key_der do
      point = OpenSSL::PKey::EC.generate(curve).public_key
      pkey = OpenSSL::PKey::EC.new point.group
      pkey.public_key = point
      pkey.to_der
    end

    has_password { [false, true].sample }
    sha1 { Digest::SHA1.hexdigest SecureRandom.hex }
    sha256 { Digest::SHA256.hexdigest SecureRandom.hex }

    curve { %w[prime256v1 secp384r1].sample }
  end
end
