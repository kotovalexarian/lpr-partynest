# frozen_string_literal: true

class RegionalOffice < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :federal_subject

  has_many :relationships

  has_many :people,
           inverse_of: :regional_office,
           through: :relationships,
           source: :person

  ###############
  # Validations #
  ###############

  validates :federal_subject, uniqueness: true
end
