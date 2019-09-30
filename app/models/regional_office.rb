# frozen_string_literal: true

class RegionalOffice < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :federal_subject

  ###############
  # Validations #
  ###############

  validates :federal_subject, uniqueness: true

  validates :name, good_small_text: true, uniqueness: true
end
