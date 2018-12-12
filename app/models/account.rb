# frozen_string_literal: true

class Account < ApplicationRecord
  rolify role_join_table_name: :account_roles

  belongs_to :person, optional: true

  has_one :user, dependent: :restrict_with_exception

  has_many :account_telegram_contacts,
           dependent: :restrict_with_exception

  has_many :own_membership_apps,
           class_name: 'MembershipApp',
           dependent:  :restrict_with_exception

  has_many :passport_confirmations, dependent: :restrict_with_exception

  scope :guests, -> { includes(:user).where(users: { id: nil }) }

  before_create do
    self.guest_token = SecureRandom.hex
  end

  validates :person_id, allow_nil: true, uniqueness: true

  def guest?
    user.nil?
  end

  def add_role(_role_name, _resource = nil)
    raise 'can not add role to guest account' if guest?

    super
  end
end
