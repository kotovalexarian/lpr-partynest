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

  validates :english_name, presence: true, uniqueness: true

  validates :native_name, presence: true, uniqueness: true

  validates :number,
            presence: true,
            uniqueness: true,
            numericality: { only_integer: true, greater_than: 0 }

  validates :timezone, presence: true, format: { with: TIMEZONE_RE }

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
end
