# frozen_string_literal: true

class Passport < ApplicationRecord
  include RequiredNameable

  FORMAT_RE = /\A[^[:space:]]+(.*[^[:space:]]+)?\z/.freeze

  ################
  # Associations #
  ################

  belongs_to :person, optional: true
  belongs_to :federal_subject, optional: true

  ###############
  # Validations #
  ###############

  validates :series, presence: true
  validates :number, presence: true
  validates :issued_by, presence: true
  validates :unit_code, presence: true
  validates :date_of_issue, presence: true

  validates :zip_code,
            allow_nil: true,
            length: { in: 1..255 },
            format: { with: FORMAT_RE }

  validates :town_type,
            allow_nil: true,
            length: { in: 1..255 },
            format: { with: FORMAT_RE }

  validates :town_name,
            allow_nil: true,
            length: { in: 1..255 },
            format: { with: FORMAT_RE }

  validates :settlement_type,
            allow_nil: true,
            length: { in: 1..255 },
            format: { with: FORMAT_RE }

  validates :settlement_name,
            allow_nil: true,
            length: { in: 1..255 },
            format: { with: FORMAT_RE }

  validates :district_type,
            allow_nil: true,
            length: { in: 1..255 },
            format: { with: FORMAT_RE }

  validates :district_name,
            allow_nil: true,
            length: { in: 1..255 },
            format: { with: FORMAT_RE }

  validates :street_type,
            allow_nil: true,
            length: { in: 1..255 },
            format: { with: FORMAT_RE }

  validates :street_name,
            allow_nil: true,
            length: { in: 1..255 },
            format: { with: FORMAT_RE }

  validates :residence_type,
            allow_nil: true,
            length: { in: 1..255 },
            format: { with: FORMAT_RE }

  validates :residence_name,
            allow_nil: true,
            length: { in: 1..255 },
            format: { with: FORMAT_RE }

  validates :building_type,
            allow_nil: true,
            length: { in: 1..255 },
            format: { with: FORMAT_RE }

  validates :building_name,
            allow_nil: true,
            length: { in: 1..255 },
            format: { with: FORMAT_RE }

  validates :apartment_type,
            allow_nil: true,
            length: { in: 1..255 },
            format: { with: FORMAT_RE }

  validates :apartment_name,
            allow_nil: true,
            length: { in: 1..255 },
            format: { with: FORMAT_RE }
end
