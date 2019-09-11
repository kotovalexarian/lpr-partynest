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

  validates :subject, presence: true

  validates :issuer, presence: true

  validates :not_before, presence: true

  validates :not_after, presence: true

  validate :can_be_parsed_and_exported_with_openssl

private

  def can_be_parsed_and_exported_with_openssl
    OpenSSL::X509::Certificate.new(pem)&.to_text if pem.present?
  rescue
    errors.add :pem
  end
end
