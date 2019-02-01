# frozen_string_literal: true

class Account < ApplicationRecord
  USERNAME_RE = /\A[a-z][_a-z0-9]*[a-z0-9]\z/.freeze

  rolify role_join_table_name: :account_roles

  belongs_to :person, optional: true

  has_one :user, dependent: :restrict_with_exception

  has_many :account_telegram_contacts,
           dependent: :restrict_with_exception

  has_one :own_membership_app,
          class_name: 'MembershipApp',
          dependent:  :restrict_with_exception

  has_many :passport_confirmations, dependent: :restrict_with_exception

  scope :guests, -> { includes(:user).where(users: { id: nil }) }

  after_initialize :generate_username

  before_create :generate_guest_token

  validates :person_id, allow_nil: true, uniqueness: true

  validates :username,
            presence:   true,
            length:     { in: 3..36 },
            format:     USERNAME_RE,
            uniqueness: { case_sensitive: false }

  validates :public_name,
            allow_nil:   true,
            allow_blank: false,
            presence:    true

  validates :biography, length: { maximum: 10_000 }

  def to_param
    username
  end

  def guest?
    user.nil?
  end

  def add_role(_role_name, _resource = nil)
    raise 'can not add role to guest account' if guest?

    super
  end

  def can_access_sidekiq_web_interface?
    is_superuser?
  end

private

  def generate_username
    self.username = "noname_#{SecureRandom.hex(8)}" if username.nil?
  end

  def generate_guest_token
    self.guest_token = SecureRandom.hex
  end
end
