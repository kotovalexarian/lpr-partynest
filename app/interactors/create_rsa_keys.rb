# frozen_string_literal: true

class CreateRSAKeys
  include Interactor

  BITS = 4096

  before :set_pkey
  before :set_ciphertext

  def call
    context.private_key_pem = @pkey.to_pem.freeze
    context.private_key_pem_key = @key

    context.public_key = RSAPublicKey.create!(
      bits: BITS,
      public_key_pem: @pkey.public_key.to_pem.freeze,
      private_key_pem_iv: @iv,
      private_key_pem_ciphertext: @ciphertext,
    )
  end

private

  def set_pkey
    @pkey = OpenSSL::PKey::RSA.new BITS
  end

  def set_ciphertext
    cipher = OpenSSL::Cipher::AES256.new
    cipher.encrypt

    @iv  = cipher.random_iv.freeze
    @key = cipher.random_key.freeze

    @ciphertext = [
      cipher.update(@pkey.to_pem),
      cipher.final,
    ].join.freeze
  end
end
