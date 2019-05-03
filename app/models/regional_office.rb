# frozen_string_literal: true

class RegionalOffice < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :country_state

  has_many :people, dependent: :restrict_with_exception

  has_many :relationships, dependent: :restrict_with_exception

  ###############
  # Validations #
  ###############

  validates :country_state, uniqueness: true
end
