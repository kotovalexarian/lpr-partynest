# frozen_string_literal: true

class Role < ApplicationRecord
  NAMES = %w[
    superuser
  ].map(&:freeze).freeze

  scopify

  ################
  # Associations #
  ################

  has_many :account_roles,
           -> { active },
           inverse_of: :role,
           dependent:  :restrict_with_exception

  has_many :accounts, through: :account_roles

  belongs_to :resource, polymorphic: true, optional: true

  ###############
  # Validations #
  ###############

  validates :name,
            presence:  true,
            inclusion: { in: NAMES }

  validates :resource_type,
            allow_nil: true,
            inclusion: { in: Rolify.resource_types }

  ###########
  # Methods #
  ###########

  def self.make!(role_name, resource = nil)
    resource_type =
      resource.is_a?(Class) ? resource.to_s : resource&.class&.name

    resource_id = resource&.id unless resource.is_a? Class

    find_or_create_by!(
      name:          role_name,
      resource_type: resource_type,
      resource_id:   resource_id,
    )
  end

  def human_name
    I18n.translate name, scope: :roles
  end

  def human_resource
    "#{resource_type} ##{resource_id}" if resource_id
  end
end
