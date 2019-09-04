# frozen_string_literal: true

class User < ApplicationRecord
  devise(
    :confirmable,
    :database_authenticatable,
    :lockable,
    :omniauthable,
    :recoverable,
    :registerable,
    :rememberable,
    :timeoutable,
    :trackable,
    :validatable,
    omniauth_providers: %i[github],
  )

  ################
  # Associations #
  ################

  belongs_to :account

  has_many :user_omniauths

  ###############
  # Validations #
  ###############

  validates :account, uniqueness: true

  #############
  # Callbacks #
  #############

  before_validation do
    self.account ||= Account.new
  end

  ###########
  # Methods #
  ###########

  def remember_exists_and_not_expired?
    return false unless respond_to? :remember_created_at
    return false unless respond_to? :remember_expired?

    remember_created_at && !remember_expired?
  end

  def remember_expired?
    remember_created_at.nil? || (remember_expires_at <= Time.now.utc)
  end

  def timedout?(last_access)
    return false if remember_exists_and_not_expired?

    !timeout_in.nil? && last_access && last_access <= timeout_in.ago
  end
end
