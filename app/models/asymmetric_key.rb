# frozen_string_literal: true

class AsymmetricKey < ApplicationRecord
  PRIVATE_KEY_CLEAR_DELAY = 1.hour.freeze

  attr_accessor :private_key_pem, :private_key_pem_secret

  ################
  # Associations #
  ################

  belongs_to :account, optional: true

  ###############
  # Validations #
  ###############

  validates :public_key_pem,
            presence: true,
            uniqueness: true

  validates :public_key_der,
            presence: true,
            uniqueness: true

  validates :has_password, exclusion: { in: [nil] }

  validates :bits,
            allow_nil: true,
            numericality: {
              only_integer: true,
              greater_than: 0,
            }

  validates :sha1,
            presence: true,
            uniqueness: { case_sensitive: false }

  validates :sha256,
            presence: true,
            uniqueness: { case_sensitive: false }

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
