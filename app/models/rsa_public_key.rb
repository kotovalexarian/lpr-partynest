# frozen_string_literal: true

class RSAPublicKey < ApplicationRecord
  attr_accessor :private_key_pem_secret

  ###############
  # Validations #
  ###############

  validates :public_key_pem, presence: true

  validates :bits, inclusion: { in: [2048, 4096] }
end
