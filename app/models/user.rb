# frozen_string_literal: true

class User < ApplicationRecord
  MIN_PASSWORD_LENGTH = 8
  MAX_PASSWORD_LENGTH = 128

  OTP_SECRET_ENCRYPTION_KEY =
    Rails.application.credentials.otp_secret_encryption_key.freeze

  devise(
    :confirmable,
    :lockable,
    :omniauthable,
    :recoverable,
    :registerable,
    :rememberable,
    :timeoutable,
    :trackable,
    :two_factor_authenticatable,
    :validatable,
    omniauth_providers:        %i[github],
    otp_secret_encryption_key: OTP_SECRET_ENCRYPTION_KEY,
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

  ###########
  # Methods #
  ###########

  def active_for_authentication?
    super && (
      !Rails.env.production?        ||
      Rails.application.restricted? ||
      !account.restricted?
    )
  end

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
