# frozen_string_literal: true

class Relationship < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :person
  belongs_to :regional_office

  ###############
  # Validations #
  ###############

  validates :number,
            presence: true,
            uniqueness: { scope: :person_id },
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
            }

  validates :supporter_since, presence: true

  validate :membership_dates_are_not_in_future
  validate :membership_is_possible

  ###########
  # Methods #
  ###########

  def status
    if excluded_since
      :excluded
    elsif member_since
      :member
    else
      :supporter
    end
  end

  def supporter?
    status == :supporter
  end

  def member?
    status == :member
  end

private

  def membership_dates_are_not_in_future
    errors.add :supporter_since unless supporter_since_not_in_future?
    errors.add :member_since    unless member_since_not_in_future?
    errors.add :excluded_since  unless excluded_since_not_in_future?
  end

  def membership_is_possible
    errors.add :member_since unless member_since_not_before_supporter_since?

    return if excluded_since_not_before_member_since? &&
              excluded_since_not_before_supporter_since?

    errors.add :excluded_since
  end

  def supporter_since_not_in_future?
    return true if supporter_since.nil?

    supporter_since <= Time.zone.today
  end

  def member_since_not_in_future?
    return true if member_since.nil?

    member_since <= Time.zone.today
  end

  def excluded_since_not_in_future?
    return true if excluded_since.nil?

    excluded_since <= Time.zone.today
  end

  def member_since_not_before_supporter_since?
    return true if member_since.nil? || supporter_since.nil?

    member_since >= supporter_since
  end

  def excluded_since_not_before_supporter_since?
    return true if excluded_since.nil? || supporter_since.nil?

    excluded_since >= supporter_since
  end

  def excluded_since_not_before_member_since?
    return true if excluded_since.nil? || member_since.nil?

    excluded_since >= member_since
  end
end
