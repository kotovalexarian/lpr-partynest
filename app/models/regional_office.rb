# frozen_string_literal: true

class RegionalOffice < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :federal_subject

  has_many :all_relationships,
           class_name: 'Relationship',
           inverse_of: :regional_office

  has_many :current_relationships,
           lambda {
             select('DISTINCT ON (relationships.person_id) *')
               .order(person_id: :asc, from_date: :desc)
           },
           class_name: 'Relationship',
           inverse_of: :regional_office

  has_many :current_supporter_relationships,
           lambda {
             select('DISTINCT ON (relationships.person_id) *')
               .where(status: :supporter)
               .order(person_id: :asc, from_date: :desc)
           },
           class_name: 'Relationship',
           inverse_of: :regional_office

  has_many :current_member_relationships,
           lambda {
             select('DISTINCT ON (relationships.person_id) *')
               .where(status: :member)
               .order(person_id: :asc, from_date: :desc)
           },
           class_name: 'Relationship',
           inverse_of: :regional_office

  has_many :current_manager_relationships,
           lambda {
             select('DISTINCT ON (relationships.person_id) *')
               .where(status: :member, role: :manager)
               .order(person_id: :asc, from_date: :desc)
           },
           class_name: 'Relationship',
           inverse_of: :regional_office

  has_many :current_supervisor_relationships,
           lambda {
             select('DISTINCT ON (relationships.person_id) *')
               .where(status: :member, role: :supervisor)
               .order(person_id: :asc, from_date: :desc)
           },
           class_name: 'Relationship',
           inverse_of: :regional_office

  has_many :all_people,
           class_name: 'Person',
           inverse_of: :regional_office,
           through: :all_relationships,
           source: :person

  has_many :current_people,
           class_name: 'Person',
           inverse_of: :regional_office,
           through: :current_relationships,
           source: :person

  has_many :current_supporter_people,
           class_name: 'Person',
           inverse_of: :regional_office,
           through: :current_supporter_relationships,
           source: :person

  has_many :current_member_people,
           class_name: 'Person',
           inverse_of: :regional_office,
           through: :current_member_relationships,
           source: :person

  has_many :current_manager_people,
           class_name: 'Person',
           inverse_of: :regional_office,
           through: :current_manager_relationships,
           source: :person

  has_many :current_supervisor_people,
           class_name: 'Person',
           inverse_of: :regional_office,
           through: :current_supervisor_relationships,
           source: :person

  ###############
  # Validations #
  ###############

  validates :federal_subject, uniqueness: true
end
