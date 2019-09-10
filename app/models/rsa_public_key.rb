# frozen_string_literal: true

class RSAPublicKey < ApplicationRecord
  ###############
  # Validations #
  ###############

  validates :pem, presence: true

  validates :bits, inclusion: { in: [2048, 4096] }
end
