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

  ##########
  # Scopes #
  ##########

  scope :federal_managers, -> { where(role: :federal_manager) }

  scope :federal_supervisors, -> { where(role: :federal_supervisor) }

  scope :federal_secretaries,
        -> { where(federal_secretary_flag: :federal_secretary) }

  scope :regional_secretaries,
        -> { where(regional_secretary_flag: :regional_secretary) }

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
