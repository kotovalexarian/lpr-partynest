# frozen_string_literal: true

class CountryState < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
