# frozen_string_literal: true

class PrivateKey
  attr_reader :asymmetric_key

  def self.policy_class
    'PrivateKeyPolicy'
  end

  def initialize(asymmetric_key)
    @asymmetric_key = asymmetric_key or raise
  end

  def exist?
    asymmetric_key.private_key_pem_iv.present? &&
      asymmetric_key.private_key_pem_ciphertext.present?
  end
end
