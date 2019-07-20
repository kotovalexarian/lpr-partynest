# frozen_string_literal: true

class Person < ApplicationRecord
  include Nameable

  ################
  # Associations #
  ################

  belongs_to :regional_office, optional: true

  belongs_to :contacts_list

  has_one :account, dependent: :restrict_with_exception

  has_many :relationships,
           -> { order(active_since: :asc) },
           inverse_of: :person,
           dependent: :restrict_with_exception

  has_one :current_relationship,
          -> { order(active_since: :desc) },
          class_name: 'Relationship',
          inverse_of: :person

  has_many :person_comments, dependent: :restrict_with_exception

  has_many :passports, dependent: :restrict_with_exception

  ###############
  # Validations #
  ###############

  validates :contacts_list, uniqueness: true
end
