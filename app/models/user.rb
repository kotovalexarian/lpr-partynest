# frozen_string_literal: true

class User < ApplicationRecord
  devise(
    :confirmable,
    :database_authenticatable,
    :lockable,
    :omniauthable,
    :recoverable,
    :registerable,
    :rememberable,
    :timeoutable,
    :trackable,
    :validatable,
    omniauth_providers: %i[github],
  )

  ################
  # Associations #
  ################

  belongs_to :account

  has_many :user_omniauths

  ###############
  # Validations #
  ###############

  validates :account, uniqueness: true

  #############
  # Callbacks #
  #############

  before_validation do
    self.account ||= Account.new
  end
end
