# frozen_string_literal: true

class EcurveKey < AsymmetricKey
  ###############
  # Validations #
  ###############

  validates :curve, inclusion: { in: %w[prime256v1 secp384r1] }

  validates :bits, absence: true
end
