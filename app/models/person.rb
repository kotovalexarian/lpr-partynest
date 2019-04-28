# frozen_string_literal: true

class Person < ApplicationRecord
  include Nameable

  ################
  # Associations #
  ################

  belongs_to :regional_office, optional: true

  has_one :account, dependent: :restrict_with_exception

  has_many :relationships, dependent: :restrict_with_exception

  has_many :passports, dependent: :restrict_with_exception

  has_many :resident_registrations, dependent: :restrict_with_exception

  has_one :own_membership_app,
          class_name: 'MembershipApp',
          inverse_of: :person,
          through: :account,
          source: :own_membership_app

  ###############
  # Validations #
  ###############

  validate :membership_is_possible
  validate :membership_dates_are_not_in_future

  ###########
  # Methods #
  ###########

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

  def membership_is_possible
    errors.add :member_since unless member_since_not_before_supporter_since?

    return if excluded_since_not_before_member_since? ||
              excluded_since_not_before_supporter_since?

    errors.add :excluded_since
  end

  def membership_dates_are_not_in_future
    errors.add :supporter_since unless supporter_since_not_in_future?
    errors.add :member_since unless member_since_not_in_future?
    errors.add :excluded_since unless excluded_since_not_in_future?
  end

  def member_since_not_before_supporter_since?
    member_since.nil? || supporter_since && member_since >= supporter_since
  end

  def excluded_since_not_before_supporter_since?
    excluded_since.nil? || supporter_since && excluded_since >= supporter_since
  end

  def excluded_since_not_before_member_since?
    excluded_since.nil? || member_since && excluded_since >= member_since
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
