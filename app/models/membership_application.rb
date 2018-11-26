# frozen_string_literal: true

class MembershipApplication < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :middle_name, presence: true
end
