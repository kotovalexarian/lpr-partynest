# frozen_string_literal: true

class RegionalOffice < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :federal_subject

  has_many :relationships, inverse_of: :regional_office

  has_many :supporter_relationships,
           -> { where(status: :supporter) },
           class_name: 'Relationship',
           inverse_of: :regional_office

  has_many :member_relationships,
           -> { where(status: :member) },
           class_name: 'Relationship',
           inverse_of: :regional_office

  has_many :manager_relationships,
           -> { where(status: :member, role: :manager) },
           class_name: 'Relationship',
           inverse_of: :regional_office

  has_many :supervisor_relationships,
           -> { where(status: :member, role: :supervisor) },
           class_name: 'Relationship',
           inverse_of: :regional_office

  has_many :people,
           inverse_of: :regional_office,
           through: :relationships,
           source: :person

  has_many :supporter_people,
           class_name: 'Person',
           inverse_of: :regional_office,
           through: :supporter_relationships,
           source: :person

  has_many :member_people,
           class_name: 'Person',
           inverse_of: :regional_office,
           through: :member_relationships,
           source: :person

  has_many :manager_people,
           class_name: 'Person',
           inverse_of: :regional_office,
           through: :manager_relationships,
           source: :person

  has_many :supervisor_people,
           class_name: 'Person',
           inverse_of: :regional_office,
           through: :supervisor_relationships,
           source: :person

  ###############
  # Validations #
  ###############

  validates :federal_subject, uniqueness: true
end
