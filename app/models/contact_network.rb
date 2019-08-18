# frozen_string_literal: true

class ContactNetwork < ApplicationRecord
  CODENAME_RE = /\A[a-z][a-z0-9]*(_[a-z0-9]+)*\z/.freeze
  FORMAT_RE = /\A[^[:space:]]+(.*[^[:space:]]+)?\z/.freeze

  ################
  # Associations #
  ################

  has_many :contacts

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
            format: FORMAT_RE

  ###########
  # Methods #
  ###########

  def to_param
    codename
  end
end
