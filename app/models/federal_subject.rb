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

  has_one :regional_office, dependent: :restrict_with_exception

  ###############
  # Validations #
  ###############

  validates :english_name, presence: true, uniqueness: true

  validates :native_name, presence: true, uniqueness: true

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
