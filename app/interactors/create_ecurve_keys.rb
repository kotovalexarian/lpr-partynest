# frozen_string_literal: true

class CreateEcurveKeys
  include Interactor

  CURVE = 'prime256v1'

  def call
    context.asymmetric_key =
      EcurveKey.create!(attributes, &:encrypt_private_key_pem)

    ClearAsymmetricPrivateKeyJob
      .set(wait: AsymmetricKey::PRIVATE_KEY_CLEAR_DELAY)
      .perform_later context.asymmetric_key.id
  end

private

  def pkey
    @pkey ||= OpenSSL::PKey::EC.generate CURVE
  end

  def pkey_public
    @pkey_public ||=
      OpenSSL::PKey::EC.new(pkey.public_key.group).tap do |pkey_public|
        pkey_public.public_key = pkey.public_key
      end
  end

  def attributes
    {
      account: context.account,

      public_key_pem: public_key_pem,
      public_key_der: public_key_der,
      private_key_pem: private_key_pem,

      has_password: context.password.present?,
      curve: CURVE,
      sha1: sha1,
      sha256: sha256,
    }
  end

  def sha1
    @sha1 ||= Digest::SHA1.hexdigest(pkey_public.to_der).freeze
  end

  def sha256
    @sha256 ||= Digest::SHA256.hexdigest(pkey_public.to_der).freeze
  end

  def public_key_pem
    @public_key_pem ||= pkey_public.to_pem.freeze
  end

  def public_key_der
    @public_key_der ||= pkey_public.to_der.freeze
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
