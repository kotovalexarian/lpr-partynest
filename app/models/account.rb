# frozen_string_literal: true

class Account < ApplicationRecord
  include Rolify::Role
  extend Rolify::Dynamic if Rolify.dynamic_shortcuts

  NICKNAME_RE = /\A[a-z][_a-z0-9]*[a-z0-9]\z/.freeze

  self.role_cname = 'Role'
  self.role_table_name = 'roles'
  self.strict_rolify = false

  self.adapter = Rolify::Adapter::Base.create 'role_adapter', role_cname, name

  ##########
  # Scopes #
  ##########

  scope :guests, -> { includes(:user).where(users: { id: nil }) }

  ################
  # Associations #
  ################

  has_one_attached :avatar

  has_many :account_roles,
           -> { active },
           inverse_of: :account,
           dependent:  :restrict_with_exception

  has_many :roles, through: :account_roles

  belongs_to :person, optional: true

  has_one :user, dependent: :restrict_with_exception

  has_one :own_membership_app,
          class_name: 'MembershipApp',
          dependent:  :restrict_with_exception

  has_many :passport_confirmations, dependent: :restrict_with_exception

  #############
  # Callbacks #
  #############

  after_initialize :generate_nickname

  before_validation :turn_blanks_into_nils
  before_validation :strip_extra_spaces

  before_create :generate_guest_token

  ###############
  # Validations #
  ###############

  validates :person, allow_nil: true, uniqueness: true

  validates :nickname,
            presence:   true,
            length:     { in: 3..36 },
            format:     NICKNAME_RE,
            uniqueness: { case_sensitive: false }

  validates :public_name, allow_nil: true, length: { in: 3..255 }

  validates :biography, allow_nil: true, length: { in: 3..10_000 }

  validates :avatar, allow_nil: true, image: true

  ###########
  # Methods #
  ###########

  def to_param
    nickname
  end

  def guest?
    user.nil?
  end

  def add_role(role_name, resource = nil)
    raise 'can not add role to guest account' if guest?

    role = self.class.role_class.make! role_name, resource

    return role if roles.include? role

    if Rolify.dynamic_shortcuts
      self.class.define_dynamic_method role.name, resource
    end

    roles << role

    role
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

  def generate_nickname
    self.nickname = "noname_#{SecureRandom.hex(8)}" if nickname.nil?
  end

  def generate_guest_token
    self.guest_token = SecureRandom.hex
  end

  def turn_blanks_into_nils
    self.public_name = nil if public_name.blank?
    self.biography   = nil if biography.blank?
  end

  def strip_extra_spaces
    self.public_name = public_name&.strip
    self.biography   = biography&.strip
  end
end
