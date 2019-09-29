# frozen_string_literal: true

class CommitteeType < ApplicationRecord
  CODENAME_RE = /\A[a-z][a-z0-9]*(_[a-z0-9]+)*\z/.freeze
  FORMAT_RE = /\A[^[:space:]]+(.*[^[:space:]]+)?\z/.freeze

  ###############
  # Validations #
  ###############

  validates :codename,
            presence: true,
            length: { in: 3..36 },
            format: CODENAME_RE,
            uniqueness: { case_sensitive: false }

  validates :name,
            presence: true,
            length: { in: 1..255 },
            format: FORMAT_RE,
            uniqueness: true

  ###########
  # Methods #
  ###########

  def to_param
    codename
  end
end
