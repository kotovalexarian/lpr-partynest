# frozen_string_literal: true

class RegionalOffice < ApplicationRecord
  FORMAT_RE = /\A[^[:space:]]+(.*[^[:space:]]+)?\z/.freeze

  ################
  # Associations #
  ################

  belongs_to :federal_subject

  ###############
  # Validations #
  ###############

  validates :federal_subject, uniqueness: true

  validates :name,
            presence: true,
            uniqueness: true,
            length: { in: 1..255 },
            format: { with: FORMAT_RE }
end
