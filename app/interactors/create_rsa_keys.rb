# frozen_string_literal: true

class CreateRSAKeys
  include Interactor

  BITS = 4096

  def call
    context.public_key = RSAPublicKey.create! do |public_key|
      pkey = OpenSSL::PKey::RSA.new BITS

      public_key.bits = BITS

      public_key.sha1   = Digest::SHA1.hexdigest   pkey.public_key.to_der
      public_key.sha256 = Digest::SHA256.hexdigest pkey.public_key.to_der

      public_key.public_key_pem  = pkey.public_key.to_pem.freeze
      public_key.private_key_pem = pkey.to_pem.freeze

      public_key.encrypt_private_key_pem
    end
  end
end
