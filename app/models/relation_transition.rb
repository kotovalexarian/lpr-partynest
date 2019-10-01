# frozen_string_literal: true

class RelationTransition < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :from_status,
             class_name: 'RelationStatus',
             inverse_of: :outgoing_transitions,
             optional: true

  belongs_to :to_status,
             class_name: 'RelationStatus'

  ###############
  # Validations #
  ###############

  validates :name, good_small_text: true, uniqueness: true

  validates :to_status, uniqueness: { scope: :from_status }

  validate :statuses_are_not_equal

private

  def statuses_are_not_equal
    return if from_status.nil? || to_status.nil? || from_status != to_status

    errors.add :to_status
  end
end
