# frozen_string_literal: true

class Role < ApplicationRecord
  has_many :account_roles, dependent: :destroy

  has_many :accounts, through: :account_roles, source: :account

  belongs_to :resource, polymorphic: true, optional: true

  validates :resource_type,
            allow_nil: true,
            inclusion: { in: Rolify.resource_types }

  scopify
end
