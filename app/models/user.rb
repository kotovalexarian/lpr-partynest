# frozen_string_literal: true

class User < ApplicationRecord
  devise(
    :confirmable,
    :database_authenticatable,
    # :lockable,
    # :omniauthable,
    # :recoverable,
    :registerable,
    :rememberable,
    # :timeoutable,
    :trackable,
    :validatable,
  )

  belongs_to :account

  validates :account_id, uniqueness: true

  before_validation do
    self.account ||= Account.new
  end
end
