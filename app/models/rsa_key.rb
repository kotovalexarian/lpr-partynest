# frozen_string_literal: true

class RSAKey < AsymmetricKey
  ###############
  # Validations #
  ###############

  validates :bits, inclusion: { in: [2048, 4096] }

  validates :curve, absence: true
end
