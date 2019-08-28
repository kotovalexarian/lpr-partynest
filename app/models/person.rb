# frozen_string_literal: true

class Person < ApplicationRecord
  include Nameable

  ################
  # Associations #
  ################

  has_one_attached :photo

  belongs_to :contact_list

  has_one :account

  has_many :all_relationships,
           -> { order(from_date: :asc) },
           class_name: 'Relationship',
           inverse_of: :person

  has_one :current_relationship,
          -> { order(from_date: :desc) },
          class_name: 'Relationship',
          inverse_of: :person

  has_many :person_comments

  has_many :passports

  ###############
  # Validations #
  ###############

  validates :contact_list, uniqueness: true

  validates :photo, allow_nil: true, image: true

  ###########
  # Methods #
  ###########

  def full_name
    [
      last_name,
      first_name,
      middle_name,
    ].map(&:presence).compact.join(' ').freeze
  end
end
