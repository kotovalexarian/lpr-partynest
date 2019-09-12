# frozen_string_literal: true

class DecryptRSAPrivateKey
  include Interactor

  def call
    cipher = OpenSSL::Cipher::AES256.new
    cipher.decrypt

    cipher.iv  = context.public_key.private_key_pem_iv
    cipher.key = context.private_key_pem_key

    context.private_key_pem_cleartext = [
      cipher.update(context.public_key.private_key_pem_ciphertext),
      cipher.final,
    ].join.freeze
  end
end
