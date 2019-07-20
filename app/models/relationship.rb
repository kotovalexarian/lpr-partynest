# frozen_string_literal: true

class Relationship < ApplicationRecord
  enum status: %i[unrelated supporter member excluded]

  ################
  # Associations #
  ################

  belongs_to :person
  belongs_to :regional_office

  ###############
  # Validations #
  ###############

  validates :start_date, presence: true, uniqueness: { scope: :person_id }

  validates :status, presence: true
end
