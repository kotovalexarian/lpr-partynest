# frozen_string_literal: true

class X509CertificateForm < ApplicationForm
  attribute :distinguished_name, :string
  attribute :not_before, :datetime
  attribute :not_after, :datetime

  def self.model_name
    ActiveModel::Name.new(self, nil, X509Certificate.name)
  end

  def self.policy_class
    'X509CertificatePolicy'
  end
end
