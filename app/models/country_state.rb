# frozen_string_literal: true

class CountryState < ApplicationRecord
  has_one :regional_office, dependent: :restrict_with_exception

  has_many :membership_apps, dependent: :restrict_with_exception

  validates :english_name, presence: true, uniqueness: true

  validates :native_name, presence: true, uniqueness: true
end
