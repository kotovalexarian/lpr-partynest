# frozen_string_literal: true

class MembershipApplication < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :date_of_birth, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true
end
