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

  validates :not_before, presence: true

  validates :not_after, presence: true
end
