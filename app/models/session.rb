# frozen_string_literal: true

class Session < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :account

  ###############
  # Validations #
  ###############

  validates :logged_at, presence: true

  validates :ip_address, presence: true
end
