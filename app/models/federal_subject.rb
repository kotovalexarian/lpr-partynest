# frozen_string_literal: true

class FederalSubject < ApplicationRecord
  TIMEZONE_RE = /\A-?\d\d:\d\d:00\z/.freeze

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

  validates :timezone, presence: true, format: { with: TIMEZONE_RE }

  validate :english_name_looks_realistic
  validate :native_name_looks_realistic
  validate :centre_looks_realistic

  ###########
  # Methods #
  ###########

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

    errors.add :english_name, :leading_spaces  if english_name.start_with? ' '
    errors.add :english_name, :trailing_spaces if english_name.end_with?   ' '
  end

  def native_name_looks_realistic
    return if native_name.blank?

    errors.add :native_name, :leading_spaces  if native_name.start_with? ' '
    errors.add :native_name, :trailing_spaces if native_name.end_with?   ' '
  end

  def centre_looks_realistic
    return if centre.blank?

    errors.add :centre, :leading_spaces  if centre.start_with? ' '
    errors.add :centre, :trailing_spaces if centre.end_with?   ' '
  end
end
