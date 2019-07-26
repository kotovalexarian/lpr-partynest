# frozen_string_literal: true

class Relationship < ApplicationRecord
  pg_enum :status, %i[supporter excluded member]

  pg_enum :role, %i[
    federal_manager
    federal_supervisor
    regional_manager
    regional_supervisor
  ]

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

  ###############
  # Validations #
  ###############

  validates :from_date, presence: true, uniqueness: { scope: :person_id }

  validates :status, presence: true

  validates :role, absence: { unless: :member? }
end
