# frozen_string_literal: true

class Account < ApplicationRecord
  include Rolify::Role
  extend Rolify::Dynamic if Rolify.dynamic_shortcuts

  USERNAME_RE = /\A[a-z][_a-z0-9]*[a-z0-9]\z/.freeze

  self.role_cname = 'Role'
  self.role_table_name = 'roles'
  self.strict_rolify = false

  self.adapter = Rolify::Adapter::Base.create 'role_adapter', role_cname, name

  has_many :account_roles,
           -> { active },
           inverse_of: :account,
           dependent:  :restrict_with_exception

  has_many :roles, through: :account_roles

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

  def add_role(role_name, resource = nil)
    raise 'can not add role to guest account' if guest?

    resource_type =
      resource.is_a?(Class) ? resource.to_s : resource&.class&.name

    resource_id = resource&.id unless resource.is_a? Class

    role = self.class.role_class.where(
      name:          role_name,
      resource_type: resource_type,
      resource_id:   resource_id,
    ).first_or_create!

    add_role_record role, resource
  end

  def remove_role(role_name, resource = nil)
    role = self.class.role_class.find_by name: role_name, resource: resource
    return if role.nil?

    account_roles.where(role: role).update_all(deleted_at: Time.zone.now)
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

  def add_role_record(role, resource)
    return role if roles.include? role

    if Rolify.dynamic_shortcuts
      self.class.define_dynamic_method role.name, resource
    end

    roles << role

    role
  end
end
