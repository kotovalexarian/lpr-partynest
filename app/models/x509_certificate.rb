# frozen_string_literal: true

class X509Certificate < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :x509_certificate_request, optional: true

  ###############
  # Validations #
  ###############

  validates :pem, presence: true
end
