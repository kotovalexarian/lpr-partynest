# frozen_string_literal: true

class PublicKeyPrivateKey
  attr_reader :public_key

  def self.policy_class
    'RSAPrivateKey'
  end

  def initialize(public_key)
    @public_key = public_key or raise
  end

  def exist?
    public_key.private_key_pem_iv.present? &&
      public_key.private_key_pem_ciphertext.present?
  end
end
