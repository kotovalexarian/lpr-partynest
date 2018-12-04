# frozen_string_literal: true

class User < ApplicationRecord
  ALLOW_UNCONFIRMED_OMNIAUTH_ACCESS_FOR = 3.days

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

  belongs_to :account

  has_many :user_omniauths, dependent: :restrict_with_exception

  validates :account_id, uniqueness: true

  before_validation do
    self.account ||= Account.new
  end

  def confirmation_period_valid?
    return if user_omniauths.where(email: email).exists? &&
              confirmation_sent_at &&
              confirmation_sent_at.utc >=
              ALLOW_UNCONFIRMED_OMNIAUTH_ACCESS_FOR.ago

    super
  end
end
