# frozen_string_literal: true

class ImportAsymmetricKey
  include Interactor

  RSA_BITS_RE = /^RSA Public-Key: \((\d+) bit\)$/.freeze
  ECURVE_CURVE_RE = /^ASN1 OID: ((-|\w)+)$/.freeze

  before :unset_asymmetric_key
  before :sanitize_public_key_der
  before :sanitize_public_key_pem
  before :set_public_key_openssl_pkey
  before :validate_public_key_der
  before :validate_public_key_pem

  def call
    if context.public_key_openssl_pkey.private?
      context.fail!
    end

    find_asymmetric_key

    return unless context.asymmetric_key.nil?

    case context.public_key_openssl_pkey
    when OpenSSL::PKey::RSA then create_rsa_key
    when OpenSSL::PKey::EC  then create_ecurve_key
    else context.fail!
    end
  end

  def find_asymmetric_key
    context.asymmetric_key = AsymmetricKey.find_by(
      public_key_der: context.public_key_openssl_pkey.to_der,
    )
  end

  def create_rsa_key
    context.asymmetric_key = RSAKey.create!(
      public_key_pem: context.public_key_openssl_pkey.to_pem,
      public_key_der: context.public_key_openssl_pkey.to_der,
      sha1: Digest::SHA1.hexdigest(context.public_key_openssl_pkey.to_der),
      sha256: Digest::SHA256.hexdigest(context.public_key_openssl_pkey.to_der),
      bits: context.public_key_openssl_pkey.to_text.lines
                   .grep(RSA_BITS_RE).first.match(RSA_BITS_RE)[1].to_i,
    )
  end

  def create_ecurve_key
    context.asymmetric_key = EcurveKey.create!(
      public_key_pem: context.public_key_openssl_pkey.to_pem,
      public_key_der: context.public_key_openssl_pkey.to_der,
      sha1: Digest::SHA1.hexdigest(context.public_key_openssl_pkey.to_der),
      sha256: Digest::SHA256.hexdigest(context.public_key_openssl_pkey.to_der),
      curve: context.public_key_openssl_pkey.to_text.lines
                    .grep(ECURVE_CURVE_RE).first.match(ECURVE_CURVE_RE)[1],
    )
  end

private

  def unset_asymmetric_key
    context.asymmetric_key = nil
  end

  def sanitize_public_key_der
    context.public_key_der = String(context.public_key_der).presence&.dup.freeze
  end

  def sanitize_public_key_pem
    context.public_key_pem = String(context.public_key_pem).lines.map do |line|
      "#{line.strip}\n"
    end.join.presence.freeze
  end

  def set_public_key_openssl_pkey
    context.public_key_openssl_pkey ||= OpenSSL::PKey.read(
      context.public_key_der || context.public_key_pem || '',
      '',
    )
  rescue OpenSSL::PKey::PKeyError
    context.fail!
  end

  def validate_public_key_der
    return if context.public_key_der.blank?
    return if context.public_key_der == context.public_key_openssl_pkey.to_der

    raise 'Invalid DER'
  end

  def validate_public_key_pem
    return if context.public_key_pem.blank?
    return if context.public_key_pem == context.public_key_openssl_pkey.to_pem

    raise 'Invalid PEM'
  end
end
