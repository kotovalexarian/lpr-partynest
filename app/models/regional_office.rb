# frozen_string_literal: true

class RegionalOffice < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :federal_subject

  has_many :all_relationships,
           class_name: 'Relationship',
           inverse_of: :regional_office

  has_many :all_people,
           class_name: 'Person',
           inverse_of: :current_regional_office,
           through: :all_relationships,
           source: :person

  ###############
  # Validations #
  ###############

  validates :federal_subject, uniqueness: true
end
