# frozen_string_literal: true

class CreateRSAKeys
  include Interactor

  BITS = 4096

  def call
    pkey = OpenSSL::PKey::RSA.new BITS

    context.private_key_pem = pkey.to_pem.freeze

    cipher = OpenSSL::Cipher::AES256.new
    cipher.encrypt

    context.private_key_pem_key = cipher.random_key.freeze

    private_key_pem_iv = cipher.random_iv

    private_key_pem_ciphertext = [
      cipher.update(context.private_key_pem),
      cipher.final,
    ].join.freeze

    context.public_key = RSAPublicKey.create!(
      bits: BITS,
      pem: pkey.public_key.to_pem.freeze,
      private_key_pem_iv: private_key_pem_iv,
      private_key_pem_ciphertext: private_key_pem_ciphertext,
    )
  end
end
