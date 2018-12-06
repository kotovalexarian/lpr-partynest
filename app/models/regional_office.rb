# frozen_string_literal: true

class RegionalOffice < ApplicationRecord
  belongs_to :country_state

  validates :country_state_id, uniqueness: true
end
