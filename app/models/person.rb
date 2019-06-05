# frozen_string_literal: true

class Person < ApplicationRecord
  include Nameable

  ################
  # Associations #
  ################

  belongs_to :regional_office, optional: true

  has_one :account, dependent: :restrict_with_exception

  has_many :relationships,
           -> { order(number: :asc) },
           inverse_of: :person,
           dependent: :restrict_with_exception

  has_one :current_relationship,
          -> { order(number: :desc) },
          class_name: 'Relationship',
          inverse_of: :person

  has_many :passports, dependent: :restrict_with_exception

  has_many :resident_registrations, dependent: :restrict_with_exception
end
