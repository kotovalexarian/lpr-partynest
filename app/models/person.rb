# frozen_string_literal: true

class Person < ApplicationRecord
  belongs_to :regional_office, optional: true

  has_one :account, dependent: :restrict_with_exception

  has_one :own_membership_app,
          class_name: 'MembershipApp',
          inverse_of: :person,
          through:    :account,
          source:     :own_membership_app

  validate :possible_member
  validate :possible_excluded

  validate :supporter_since_not_in_future
  validate :member_since_not_in_future
  validate :excluded_since_not_in_future

  def party_supporter?
    supporter_since.present? && !excluded_from_party?
  end

  def party_member?
    member_since.present? && !excluded_from_party?
  end

  def excluded_from_party?
    excluded_since.present?
  end

private

  def possible_member
    return if member_since.nil?

    return errors.add :member_since if supporter_since.nil?
    return errors.add :member_since if member_since < supporter_since

    nil
  end

  def possible_excluded
    return if excluded_since.nil?

    return errors.add :excluded_since if supporter_since.nil? &&
                                         member_since.nil?
    return errors.add :excluded_since if supporter_since &&
                                         excluded_since < supporter_since
    return errors.add :excluded_since if member_since &&
                                         excluded_since < member_since

    nil
  end

  def supporter_since_not_in_future
    errors.add :supporter_since unless supporter_since_not_in_future?
  end

  def member_since_not_in_future
    errors.add :member_since unless member_since_not_in_future?
  end

  def excluded_since_not_in_future
    errors.add :excluded_since unless excluded_since_not_in_future?
  end

  def supporter_since_not_in_future?
    supporter_since.nil? || supporter_since <= Time.zone.today
  end

  def member_since_not_in_future?
    member_since.nil? || member_since <= Time.zone.today
  end

  def excluded_since_not_in_future?
    excluded_since.nil? || excluded_since <= Time.zone.today
  end
end
