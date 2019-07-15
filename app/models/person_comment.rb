# frozen_string_literal: true

class PersonComment < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :person

  belongs_to :account, optional: true

  ###############
  # Validations #
  ###############

  validates :text, presence: true, length: { in: 1..10_000 }
end
