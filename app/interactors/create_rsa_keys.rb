# frozen_string_literal: true

class CreateRSAKeys
  include Interactor

  BITS = 4096

  def call
    context.key = RSAKey.create!(attributes, &:encrypt_private_key_pem)

    ClearAsymmetricPrivateKeyJob
      .set(wait: AsymmetricKey::PRIVATE_KEY_CLEAR_DELAY)
      .perform_later context.key.id
  end

private

  def attributes
    pkey = OpenSSL::PKey::RSA.new BITS

    {
      bits: BITS,

      sha1: Digest::SHA1.hexdigest(pkey.public_key.to_der),
      sha256: Digest::SHA256.hexdigest(pkey.public_key.to_der),

      public_key_pem: pkey.public_key.to_pem.freeze,
      public_key_der: pkey.public_key.to_der.freeze,
      private_key_pem: pkey.to_pem.freeze,
    }
  end
end
