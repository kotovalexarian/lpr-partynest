# frozen_string_literal: true

class MembershipPool < ApplicationRecord
  has_many :membership_pool_apps, dependent: :restrict_with_exception

  has_many :membership_apps, through: :membership_pool_apps

  has_many :membership_pool_accounts, dependent: :restrict_with_exception

  has_many :accounts, through: :membership_pool_accounts

  scope :with_account, lambda { |account|
    includes(:membership_pool_accounts)
      .where(membership_pool_accounts: { account: account })
  }

  validates :name, presence: true
end
