# frozen_string_literal: true

class RSAPublicKey < ApplicationRecord
  attr_accessor :private_key_pem, :private_key_pem_secret

  ###############
  # Validations #
  ###############

  validates :public_key_pem, presence: true

  validates :bits, inclusion: { in: [2048, 4096] }

  ###########
  # Methods #
  ###########

  def encrypt_private_key_pem
    cipher = OpenSSL::Cipher::AES256.new
    cipher.encrypt

    self.private_key_pem_iv     = cipher.random_iv.freeze
    self.private_key_pem_secret = cipher.random_key.freeze

    self.private_key_pem_ciphertext = [
      cipher.update(private_key_pem),
      cipher.final,
    ].join.freeze

    private_key_pem_secret
  end

  def decrypt_private_key_pem
    cipher = OpenSSL::Cipher::AES256.new
    cipher.decrypt

    cipher.iv  = private_key_pem_iv
    cipher.key = private_key_pem_secret

    self.private_key_pem = [
      cipher.update(private_key_pem_ciphertext),
      cipher.final,
    ].join.freeze
  end
end
