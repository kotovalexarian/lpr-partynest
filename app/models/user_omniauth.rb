# frozen_string_literal: true

class UserOmniauth < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :user

  ###############
  # Validations #
  ###############

  validates :provider, presence: true, uniqueness: { scope: :remote_id }

  validates :remote_id, presence: true

  validates :email, presence: true
end
