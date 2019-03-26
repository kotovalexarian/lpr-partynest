# frozen_string_literal: true

class PassportMap < ApplicationRecord
  include Nameable

  ################
  # Associations #
  ################

  belongs_to :passport

  ###############
  # Validations #
  ###############

  validates :series, presence: true
  validates :number, presence: true
  validates :issued_by, presence: true
  validates :unit_code, presence: true
  validates :date_of_issue, presence: true
end
