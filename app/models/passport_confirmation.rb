# frozen_string_literal: true

class PassportConfirmation < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :passport
  belongs_to :account

  ###############
  # Validations #
  ###############

  validates :account, uniqueness: { scope: :passport_id }

  validate :passport_can_have_confirmations

private

  def passport_can_have_confirmations
    return if passport.nil? || passport.can_have_confirmations?

    errors.add :passport, 'must have a passport map and an image'
  end
end
