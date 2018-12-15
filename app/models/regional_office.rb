# frozen_string_literal: true

class RegionalOffice < ApplicationRecord
  belongs_to :country_state

  has_many :membership_apps, through: :country_state

  has_many :people, dependent: :restrict_with_exception

  validates :country_state_id, uniqueness: true
end
