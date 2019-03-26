# frozen_string_literal: true

class CountryState < ApplicationRecord
  ################
  # Associations #
  ################

  has_one :regional_office, dependent: :restrict_with_exception

  has_many :membership_apps, dependent: :restrict_with_exception

  ###############
  # Validations #
  ###############

  validates :english_name, presence: true, uniqueness: true

  validates :native_name, presence: true, uniqueness: true

  ###########
  # Methods #
  ###########

  def display_name
    return native_name if I18n.locale == :ru

    english_name
  end
end
