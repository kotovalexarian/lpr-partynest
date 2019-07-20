# frozen_string_literal: true

class Relationship < ApplicationRecord
  enum status: %i[supporter excluded member]

  enum role: %i[manager supervisor]

  ################
  # Associations #
  ################

  belongs_to :person, inverse_of: :relationships

  belongs_to :regional_office, inverse_of: :all_relationships

  ###############
  # Validations #
  ###############

  validates :from_date, presence: true, uniqueness: { scope: :person_id }

  validates :status, presence: true

  validates :role, absence: { unless: :member? }
end
