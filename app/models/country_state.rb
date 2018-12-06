# frozen_string_literal: true

class CountryState < ApplicationRecord
  has_many :membership_apps, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
end
