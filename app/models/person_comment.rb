# frozen_string_literal: true

class PersonComment < ApplicationRecord
  default_scope { order(created_at: :asc) }

  ################
  # Associations #
  ################

  belongs_to :person

  belongs_to :account, optional: true

  has_one_attached :attachment

  ###############
  # Validations #
  ###############

  validates :text, presence: true, length: { in: 1..10_000 }
end
