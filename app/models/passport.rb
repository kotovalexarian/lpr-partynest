# frozen_string_literal: true

class Passport < ApplicationRecord
  include RequiredNameable

  ################
  # Associations #
  ################

  belongs_to :person, optional: true
  belongs_to :federal_subject, optional: true

  ###############
  # Validations #
  ###############

  validates :series,        presence: true
  validates :number,        presence: true
  validates :issued_by,     presence: true
  validates :unit_code,     presence: true
  validates :date_of_issue, presence: true

  validates :zip_code,        allow_nil: true, good_small_text: true
  validates :town_type,       allow_nil: true, good_small_text: true
  validates :town_name,       allow_nil: true, good_small_text: true
  validates :settlement_type, allow_nil: true, good_small_text: true
  validates :settlement_name, allow_nil: true, good_small_text: true
  validates :district_type,   allow_nil: true, good_small_text: true
  validates :district_name,   allow_nil: true, good_small_text: true
  validates :street_type,     allow_nil: true, good_small_text: true
  validates :street_name,     allow_nil: true, good_small_text: true
  validates :residence_type,  allow_nil: true, good_small_text: true
  validates :residence_name,  allow_nil: true, good_small_text: true
  validates :building_type,   allow_nil: true, good_small_text: true
  validates :building_name,   allow_nil: true, good_small_text: true
  validates :apartment_type,  allow_nil: true, good_small_text: true
  validates :apartment_name,  allow_nil: true, good_small_text: true
end
