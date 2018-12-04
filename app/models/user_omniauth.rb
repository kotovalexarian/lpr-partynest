# frozen_string_literal: true

class UserOmniauth < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true, uniqueness: { scope: :remote_id }
  validates :remote_id, presence: true
  validates :email, presence: true
end
