# frozen_string_literal: true

class Role < ApplicationRecord
  has_many :user_roles, dependent: :destroy

  has_many :users, through: :user_roles, source: :user

  belongs_to :resource, polymorphic: true, optional: true

  validates :resource_type,
            allow_nil: true,
            inclusion: { in: Rolify.resource_types }

  scopify
end
