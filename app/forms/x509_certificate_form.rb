# frozen_string_literal: true

class X509CertificateForm < ApplicationForm
  attribute :distinguished_name, :string
  attribute :not_before, :datetime
  attribute :not_after, :datetime

  validates :distinguished_name, presence: true

  validates :not_before, presence: true

  validates :not_after, presence: true

  validate :can_be_parsed_with_openssl

  def self.model_name
    ActiveModel::Name.new(self, nil, X509Certificate.name)
  end

  def self.policy_class
    'X509CertificatePolicy'
  end

private

  def can_be_parsed_with_openssl
    OpenSSL::X509::Name.parse distinguished_name if distinguished_name.present?
  rescue
    errors.add :distinguished_name
  end
end
