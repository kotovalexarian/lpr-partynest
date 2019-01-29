# frozen_string_literal: true

class Person < ApplicationRecord
  belongs_to :regional_office, optional: true

  has_one :account, dependent: :restrict_with_exception

  has_one :own_membership_app,
          class_name: 'MembershipApp',
          inverse_of: :person,
          through:    :account,
          source:     :own_membership_app

  validate :supporter_since_not_in_future
  validate :member_since_not_in_future

  def party_supporter?
    supporter_since.present?
  end

  def party_member?
    member_since.present?
  end

  def excluded_from_party?
    false
  end

private

  def supporter_since_not_in_future
    return if supporter_since.nil?

    errors.add :supporter_since unless supporter_since <= Time.zone.today
  end

  def member_since_not_in_future
    return if member_since.nil?

    errors.add :member_since unless member_since <= Time.zone.today
  end
end
