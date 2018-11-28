# frozen_string_literal: true

class MembershipApplication < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :date_of_birth, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true

  before_validation do
    self.middle_name             = nil if middle_name.blank?
    self.occupation              = nil if occupation.blank?
    self.telegram_username       = nil if telegram_username.blank?
    self.organization_membership = nil if organization_membership.blank?
    self.comment                 = nil if comment.blank?
  end
end
