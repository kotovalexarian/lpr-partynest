# frozen_string_literal: true

class Relationship < ApplicationRecord
  pg_enum :status, %i[supporter excluded member]

  pg_enum :role, %i[regional_manager supervisor]

  ################
  # Associations #
  ################

  belongs_to :person, inverse_of: :all_relationships

  belongs_to :regional_office, inverse_of: :all_relationships

  ###############
  # Validations #
  ###############

  validates :from_date, presence: true, uniqueness: { scope: :person_id }

  validates :status, presence: true

  validates :role, absence: { unless: :member? }
end
