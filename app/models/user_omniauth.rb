# frozen_string_literal: true

class UserOmniauth < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :user

  has_one :assumed_user,
          class_name: 'User',
          primary_key: :email,
          foreign_key: :email,
          inverse_of: false,
          autosave: false,
          dependent: false

  ###############
  # Validations #
  ###############

  validates :provider, presence: true, uniqueness: { scope: :remote_id }

  validates :remote_id, presence: true

  validates :email, presence: true

  validates :assumed_user, inclusion: { in: :expected_users }

private

  def expected_users
    [nil, user]
  end
end
