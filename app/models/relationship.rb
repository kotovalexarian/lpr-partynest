# frozen_string_literal: true

class Relationship < ApplicationRecord
  enum status: {
    supporter: 'supporter',
    excluded: 'excluded',
    member: 'member',
  }

  enum role: {
    manager: 'manager',
    supervisor: 'supervisor',
  }

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
