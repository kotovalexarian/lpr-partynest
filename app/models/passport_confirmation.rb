# frozen_string_literal: true

class PassportConfirmation < ApplicationRecord
  belongs_to :passport
  belongs_to :account

  validates :account_id, uniqueness: { scope: :passport_id }

  validate :passport_has_image

private

  def passport_has_image
    return if passport.nil?

    errors.add :passport, 'must have an image' if passport.image.nil?
  end
end
