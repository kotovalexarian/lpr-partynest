# frozen_string_literal: true

class Role < ApplicationRecord
  NAMES = %w[
    superuser
  ].map(&:freeze).freeze

  has_and_belongs_to_many :accounts, join_table: :account_roles

  belongs_to :resource, polymorphic: true, optional: true

  validates :name,
            presence:  true,
            inclusion: { in: NAMES }

  validates :resource_type,
            allow_nil: true,
            inclusion: { in: Rolify.resource_types }

  scopify
end
