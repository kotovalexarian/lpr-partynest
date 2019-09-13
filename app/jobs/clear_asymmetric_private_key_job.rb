# frozen_string_literal: true

class ClearAsymmetricPrivateKeyJob < ApplicationJob
  queue_as :default

  def perform(asymmetric_key_id)
    AsymmetricKey
      .find(asymmetric_key_id)
      .update! private_key_pem_iv: nil, private_key_pem_ciphertext: nil
  end
end
