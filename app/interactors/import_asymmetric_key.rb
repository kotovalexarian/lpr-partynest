# frozen_string_literal: true

class ImportAsymmetricKey
  include Interactor

  RSA_BITS_RE = /^RSA Public-Key: \((\d+) bit\)$/.freeze
  ECURVE_CURVE_RE = /^ASN1 OID: ((-|\w)+)$/.freeze

  def call; end
end
