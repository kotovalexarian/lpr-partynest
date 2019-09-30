# frozen_string_literal: true

class Relationship < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :status, class_name: 'RelationStatus'

  belongs_to :person, inverse_of: :all_relationships

  belongs_to :regional_office

  ###############
  # Validations #
  ###############

  validates :from_date, presence: true, uniqueness: { scope: :person_id }
end
