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

  validates :number,
            presence: true,
            uniqueness: { scope: :person_id },
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
            }

  validates :active_since, presence: true

  validates :status, presence: true
end
