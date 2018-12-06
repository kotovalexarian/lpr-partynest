# frozen_string_literal: true

class MembershipPool < ApplicationRecord
  validates :name, presence: true
end
