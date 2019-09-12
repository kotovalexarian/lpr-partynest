# frozen_string_literal: true

class DecryptRSAPrivateKey
  include Interactor

  before :set_cipher

  def call
    context.private_key_pem_cleartext = [
      @cipher.update(context.public_key.private_key_pem_ciphertext),
      @cipher.final,
    ].join.freeze
  end

private

  def set_cipher
    @cipher = OpenSSL::Cipher::AES256.new
    @cipher.decrypt

    @cipher.iv  = context.public_key.private_key_pem_iv
    @cipher.key = context.public_key.private_key_pem_secret
  end
end
