# frozen_string_literal: true

class AsymmetricKeyForm < ApplicationForm
  attr_reader :public_key_openssl_pkey

  attribute :public_key_pem, :string

  before_validation :set_public_key_openssl_pkey

  validates :public_key_pem, presence: true

  def self.model_name
    ActiveModel::Name.new(self, nil, AsymmetricKey.name)
  end

  def self.policy_class
    'AsymmetricKeyPolicy'
  end

private

  def set_public_key_openssl_pkey
    return @public_key_openssl_pkey = nil if public_key_pem.blank?

    @public_key_openssl_pkey = OpenSSL::PKey.read public_key_pem
  rescue OpenSSL::OpenSSLError
    @public_key_openssl_pkey = nil
    errors.add :public_key_pem
  end
end
