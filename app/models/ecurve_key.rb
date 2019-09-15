# frozen_string_literal: true

class EcurveKey < AsymmetricKey
  ALGO_CLASS = 'Elliptic curve'
  CURVES = %w[prime256v1 secp384r1].freeze

  ###############
  # Validations #
  ###############

  validates :curve, inclusion: { in: CURVES }

  validates :bits, absence: true

  ###########
  # Methods #
  ###########

  def algo_class
    ALGO_CLASS
  end

  def algo_variant
    curve
  end
end
