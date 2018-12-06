# frozen_string_literal: true

class MembershipPool < ApplicationRecord
  has_many :membership_pool_apps, dependent: :restrict_with_exception

  has_many :membership_apps, through: :membership_pool_apps

  has_many :membership_pool_accounts, dependent: :restrict_with_exception

  has_many :accounts, through: :membership_pool_accounts

  validates :name, presence: true
end
