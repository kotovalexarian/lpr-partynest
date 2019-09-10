# frozen_string_literal: true

class CreateRSAKeys
  include Interactor

  BITS = 4096

  def call
    pkey = OpenSSL::PKey::RSA.new BITS

    context.private_key_pem = pkey.to_pem.freeze

    context.public_key = RSAPublicKey.create!(
      bits: BITS,
      pem: pkey.public_key.to_pem.freeze,
    )
  end
end
