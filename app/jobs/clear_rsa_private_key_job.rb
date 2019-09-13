# frozen_string_literal: true

class ClearRSAPrivateKeyJob < ApplicationJob
  queue_as :default

  def perform(rsa_public_key_id)
    RSAPublicKey
      .find(rsa_public_key_id)
      .update! private_key_pem_iv: nil, private_key_pem_ciphertext: nil
  end
end
