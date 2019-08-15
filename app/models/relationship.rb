# frozen_string_literal: true

class Relationship < ApplicationRecord
  pg_enum :status, %i[supporter excluded member]

  pg_enum :role, %i[
    federal_manager
    federal_supervisor
    regional_manager
    regional_supervisor
  ]

  pg_enum :federal_secretary_flag, %i[federal_secretary]

  pg_enum :regional_secretary_flag, %i[regional_secretary]

  ################
  # Associations #
  ################

  belongs_to :person, inverse_of: :all_relationships

  belongs_to :regional_office, inverse_of: :all_relationships

  belongs_to :initiator_account,
             class_name: 'Account',
             inverse_of: false,
             optional: true

  ##########
  # Scopes #
  ##########

  scope :supporters, -> { where(status: :supporter) }

  scope :excluded, -> { where(status: :excluded) }

  scope :members, -> { where(status: :member) }

  scope :federal_managers, -> { members.where(role: :federal_manager) }

  scope :federal_supervisors, -> { members.where(role: :federal_supervisor) }

  scope :federal_secretaries, lambda {
    federal_managers.where(federal_secretary_flag: :federal_secretary)
  }

  scope :regional_managers, -> { members.where(role: :regional_manager) }

  scope :regional_supervisors, -> { members.where(role: :regional_supervisor) }

  scope :regional_secretaries, lambda {
    regional_managers.where(regional_secretary_flag: :regional_secretary)
  }

  ###############
  # Validations #
  ###############

  validates :from_date, presence: true, uniqueness: { scope: :person_id }

  validates :status, presence: true

  validates :role, absence: { unless: :member? }

  validates :federal_secretary_flag,
            allow_nil: true,
            absence: { unless: :federal_manager? },
            uniqueness: true

  validates :regional_secretary_flag,
            allow_nil: true,
            absence: { unless: :regional_manager? },
            uniqueness: { scope: :regional_office_id }
end
