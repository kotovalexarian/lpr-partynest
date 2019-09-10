# frozen_string_literal: true

class X509CertificateRequest < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :rsa_public_key

  ###############
  # Validations #
  ###############

  validates :distinguished_name,
            presence: true,
            length: { maximum: 10_000 }

  validates :pem, presence: true
end
