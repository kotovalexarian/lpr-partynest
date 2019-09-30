# frozen_string_literal: true

class FederalSubject < ApplicationRecord
  ##########
  # Scopes #
  ##########

  scope :order_by_display_name, lambda { |dir = :asc|
    if I18n.locale == :ru
      order(native_name: dir)
    else
      order(english_name: dir)
    end
  }

  ################
  # Associations #
  ################

  has_one :regional_office

  ###############
  # Validations #
  ###############

  validates :english_name,
            presence: true,
            uniqueness: true,
            length: { in: 1..255 }

  validates :native_name,
            presence: true,
            uniqueness: true,
            length: { in: 1..255 }

  validates :centre,
            presence: true,
            length: { in: 1..255 }

  validates :number,
            presence: true,
            uniqueness: true,
            numericality: { only_integer: true, greater_than: 0 }

  validates :timezone, timezone: true

  validate :english_name_looks_realistic
  validate :native_name_looks_realistic
  validate :centre_looks_realistic

  ###########
  # Methods #
  ###########

  def to_param
    number&.to_s
  end

  def display_name
    if I18n.locale == :ru
      native_name
    else
      english_name
    end
  end

private

  def english_name_looks_realistic
    return if english_name.blank?

    errors.add :english_name, :leading_spaces  if english_name.match?(/\A\s+/)
    errors.add :english_name, :trailing_spaces if english_name.match?(/\s+\z/)
  end

  def native_name_looks_realistic
    return if native_name.blank?

    errors.add :native_name, :leading_spaces  if native_name.match?(/\A\s+/)
    errors.add :native_name, :trailing_spaces if native_name.match?(/\s+\z/)
  end

  def centre_looks_realistic
    return if centre.blank?

    errors.add :centre, :leading_spaces  if centre.match?(/\A\s+/)
    errors.add :centre, :trailing_spaces if centre.match?(/\s+\z/)
  end
end
