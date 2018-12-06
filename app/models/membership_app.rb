# frozen_string_literal: true

class MembershipApp < ApplicationRecord
  belongs_to :account
  belongs_to :country_state, optional: true

  has_many :membership_pool_apps, dependent: :restrict_with_exception

  has_many :membership_pools, through: :membership_pool_apps

  validates :email, presence: true, format: Devise.email_regexp

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :date_of_birth, presence: true
  validates :phone_number, presence: true

  before_validation do
    email&.strip!

    self.middle_name             = nil if middle_name.blank?
    self.occupation              = nil if occupation.blank?
    self.telegram_username       = nil if telegram_username.blank?
    self.organization_membership = nil if organization_membership.blank?
    self.comment                 = nil if comment.blank?
  end
end