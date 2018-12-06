# frozen_string_literal: true

class MembershipPoolAccount < ApplicationRecord
  belongs_to :membership_pool
  belongs_to :account

  validates :account_id, uniqueness: { scope: :membership_pool_id }
end
