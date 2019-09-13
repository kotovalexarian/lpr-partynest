# frozen_string_literal: true

class ClearRSAPrivateKeyJob < ApplicationJob
  queue_as :default

  def perform(rsa_key_id)
    RSAKey
      .find(rsa_key_id)
      .update! private_key_pem_iv: nil, private_key_pem_ciphertext: nil
  end
end
