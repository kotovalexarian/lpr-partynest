# frozen_string_literal: true

class Account < ApplicationRecord
  rolify role_join_table_name: :account_roles

  has_one :user, dependent: :restrict_with_exception

  has_many :membership_apps, dependent: :restrict_with_exception

  has_many :passport_confirmations, dependent: :restrict_with_exception

  has_many :membership_pool_accounts, dependent: :restrict_with_exception

  has_many :membership_pools, through: :membership_pool_accounts

  scope :guests, -> { includes(:user).where(users: { id: nil }) }

  def guest?
    user.nil?
  end

  def add_role(_role_name, _resource = nil)
    raise 'can not add role to guest account' if guest?

    super
  end
end
