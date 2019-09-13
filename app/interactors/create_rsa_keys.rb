# frozen_string_literal: true

class CreateRSAKeys
  include Interactor

  BITS = 4096

  def call
    context.asymmetric_key =
      RSAKey.create!(attributes, &:encrypt_private_key_pem)

    ClearAsymmetricPrivateKeyJob
      .set(wait: AsymmetricKey::PRIVATE_KEY_CLEAR_DELAY)
      .perform_later context.asymmetric_key.id
  end

private

  def pkey
    @pkey ||= OpenSSL::PKey::RSA.new BITS
  end

  def attributes
    {
      account: context.account,

      public_key_pem: public_key_pem,
      public_key_der: public_key_der,
      private_key_pem: private_key_pem,

      has_password: context.password.present?,
      bits: BITS,
      sha1: sha1,
      sha256: sha256,
    }
  end

  def sha1
    @sha1 ||= Digest::SHA1.hexdigest(pkey.public_key.to_der).freeze
  end

  def sha256
    @sha256 ||= Digest::SHA256.hexdigest(pkey.public_key.to_der).freeze
  end

  def public_key_pem
    @public_key_pem ||= pkey.public_key.to_pem.freeze
  end

  def public_key_der
    @public_key_der ||= pkey.public_key.to_der.freeze
  end

  def private_key_pem
    @private_key_pem ||=
      if context.password.present?
        pkey.to_pem(OpenSSL::Cipher::AES256.new, context.password).freeze
      else
        pkey.to_pem.freeze
      end
  end
end
