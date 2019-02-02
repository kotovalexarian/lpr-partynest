# frozen_string_literal: true

class Role < ApplicationRecord
  NAMES = %w[
    superuser
  ].map(&:freeze).freeze

  has_many :account_roles,
           -> { where deleted_at: nil },
           inverse_of: :role,
           dependent:  :restrict_with_exception

  has_many :accounts, through: :account_roles

  belongs_to :resource, polymorphic: true, optional: true

  validates :name,
            presence:  true,
            inclusion: { in: NAMES }

  validates :resource_type,
            allow_nil: true,
            inclusion: { in: Rolify.resource_types }

  scopify

  def human_name
    I18n.translate name, scope: :roles
  end

  def human_resource
    "#{resource_type} ##{resource_id}" if resource_id
  end
end
