# frozen_string_literal: true

class RelationStatus < ApplicationRecord
  CODENAME_RE = /\A[a-z][a-z0-9]*(_[a-z0-9]+)*\z/.freeze
  FORMAT_RE = /\A[^[:space:]]+(.*[^[:space:]]+)?\z/.freeze

  ################
  # Associations #
  ################

  has_many :transitions,
           class_name: 'RelationTransition',
           inverse_of: :from_status,
           foreign_key: :from_status_id,
           dependent: :restrict_with_exception

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
