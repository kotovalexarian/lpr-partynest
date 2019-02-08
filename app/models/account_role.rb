# frozen_string_literal: true

class AccountRole < ApplicationRecord
  belongs_to :account
  belongs_to :role

  scope :active, -> { not_deleted.not_expired }

  scope :not_deleted, -> { where(deleted_at: nil) }

  scope :not_expired, lambda {
    where(
      arel_table[:expires_at].eq(nil).or(
        arel_table[:expires_at].gt(Time.zone.now),
      ),
    )
  }

  validate :deleted_at_is_not_in_future

private

  def deleted_at_is_not_in_future
    return if deleted_at.nil?

    errors.add :deleted_at unless deleted_at <= Time.zone.now + 10
  end
end
