# frozen_string_literal: true

class MembershipPoolApp < ApplicationRecord
  belongs_to :membership_pool
  belongs_to :membership_app

  validates :membership_pool_id, uniqueness: { scope: :membership_app_id }
end
