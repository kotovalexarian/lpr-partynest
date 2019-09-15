# frozen_string_literal: true

class AsymmetricKeyForm < ApplicationForm
  attribute :public_key_pem, :string

  validates :public_key_pem, presence: true

  def self.model_name
    ActiveModel::Name.new(self, nil, AsymmetricKey.name)
  end

  def self.policy_class
    'AsymmetricKeyPolicy'
  end
end
