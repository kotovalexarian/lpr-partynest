# frozen_string_literal: true

class RSAKey < AsymmetricKey
  ALGO_CLASS = 'RSA'
  BITS = [2048, 4096].freeze

  ###############
  # Validations #
  ###############

  validates :bits, inclusion: { in: BITS }

  validates :curve, absence: true

  ###########
  # Methods #
  ###########

  def algo_class
    ALGO_CLASS
  end

  def algo_variant
    "#{bits} bits"
  end
end
