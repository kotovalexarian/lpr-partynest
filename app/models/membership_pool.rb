# frozen_string_literal: true

class MembershipPool < ApplicationRecord
  has_many :membership_pool_apps, dependent: :restrict_with_exception

  has_many :membership_apps, through: :membership_pool_apps

  validates :name, presence: true
end
