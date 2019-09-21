# frozen_string_literal: true

class RelationTransition < ApplicationRecord
  FORMAT_RE = /\A[^[:space:]]+(.*[^[:space:]]+)?\z/.freeze

  ################
  # Associations #
  ################

  belongs_to :from_status,
             class_name: 'RelationStatus',
             optional: true

  belongs_to :to_status,
             class_name: 'RelationStatus'

  ###############
  # Validations #
  ###############

  validates :name,
            presence: true,
            length: { in: 1..255 },
            format: FORMAT_RE,
            uniqueness: true

  validate :statuses_are_not_equal

private

  def statuses_are_not_equal
    return if from_status.nil? || to_status.nil? || from_status != to_status

    errors.add :to_status
  end
end
