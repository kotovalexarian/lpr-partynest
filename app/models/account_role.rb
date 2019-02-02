# frozen_string_literal: true

class AccountRole < ApplicationRecord
  belongs_to :account
  belongs_to :role

  scope :active, -> { where(deleted_at: nil) }

  validate :deleted_at_is_not_in_future

private

  def deleted_at_is_not_in_future
    return if deleted_at.nil?

    errors.add :deleted_at unless deleted_at <= Time.zone.now + 10
  end
end
