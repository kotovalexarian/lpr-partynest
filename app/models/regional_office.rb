# frozen_string_literal: true

class RegionalOffice < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :federal_subject

  has_many :people, dependent: :restrict_with_exception

  has_many :relationships, dependent: :restrict_with_exception

  ###############
  # Validations #
  ###############

  validates :federal_subject, uniqueness: true
end
