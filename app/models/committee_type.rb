# frozen_string_literal: true

class CommitteeType < ApplicationRecord
  FORMAT_RE = /\A[^[:space:]]+(.*[^[:space:]]+)?\z/.freeze

  ###############
  # Validations #
  ###############

  validates :codename,
            presence: true,
            codename: true,
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
