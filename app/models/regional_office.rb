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
               .supporters
               .order(person_id: :asc, from_date: :desc)
           },
           class_name: 'Relationship',
           inverse_of: :regional_office

  has_many :current_member_relationships,
           lambda {
             select('DISTINCT ON (relationships.person_id) *')
               .members
               .order(person_id: :asc, from_date: :desc)
           },
           class_name: 'Relationship',
           inverse_of: :regional_office

  has_many :current_regional_manager_relationships,
           lambda {
             select('DISTINCT ON (relationships.person_id) *')
               .regional_managers
               .order(person_id: :asc, from_date: :desc)
           },
           class_name: 'Relationship',
           inverse_of: :regional_office

  has_many :current_regional_supervisor_relationships,
           lambda {
             select('DISTINCT ON (relationships.person_id) *')
               .regional_supervisors
               .order(person_id: :asc, from_date: :desc)
           },
           class_name: 'Relationship',
           inverse_of: :regional_office

  has_one :current_regional_secretary_relationship,
          lambda {
            select('DISTINCT ON (relationships.person_id) *')
              .regional_secretaries
              .order(person_id: :asc, from_date: :desc)
          },
          class_name: 'Relationship',
          inverse_of: :regional_office

  has_many :all_people,
           class_name: 'Person',
           inverse_of: :current_regional_office,
           through: :all_relationships,
           source: :person

  has_many :current_people,
           class_name: 'Person',
           inverse_of: :current_regional_office,
           through: :current_relationships,
           source: :person

  has_many :current_supporter_people,
           class_name: 'Person',
           inverse_of: :current_regional_office,
           through: :current_supporter_relationships,
           source: :person

  has_many :current_member_people,
           class_name: 'Person',
           inverse_of: :current_regional_office,
           through: :current_member_relationships,
           source: :person

  has_many :current_regional_manager_people,
           class_name: 'Person',
           inverse_of: :current_regional_office,
           through: :current_regional_manager_relationships,
           source: :person

  has_many :current_regional_supervisor_people,
           class_name: 'Person',
           inverse_of: :current_regional_office,
           through: :current_regional_supervisor_relationships,
           source: :person

  has_one :current_regional_secretary_person,
          class_name: 'Person',
          inverse_of: :current_regional_office,
          through: :current_regional_secretary_relationship,
          source: :person

  has_many :all_accounts,
           class_name: 'Account',
           through: :all_people,
           source: :account

  has_many :current_accounts,
           class_name: 'Account',
           through: :current_people,
           source: :account

  has_many :current_supporter_accounts,
           class_name: 'Account',
           through: :current_supporter_people,
           source: :account

  has_many :current_member_accounts,
           class_name: 'Account',
           through: :current_member_people,
           source: :account

  has_many :current_regional_manager_accounts,
           class_name: 'Account',
           through: :current_regional_manager_people,
           source: :account

  has_many :current_regional_supervisor_accounts,
           class_name: 'Account',
           through: :current_regional_supervisor_people,
           source: :account

  has_one :current_regional_secretary_account,
          class_name: 'Account',
          through: :current_regional_secretary_person,
          source: :account

  ###############
  # Validations #
  ###############

  validates :federal_subject, uniqueness: true
end
