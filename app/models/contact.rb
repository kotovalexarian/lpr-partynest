# frozen_string_literal: true

class Contact < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :contact_list
  belongs_to :contact_network

  #############
  # Callbacks #
  #############

  before_validation :turn_blanks_into_nils
  before_validation :strip_extra_spaces

  ###############
  # Validations #
  ###############

  validates :contact_list, presence: true

  validates :contact_network, presence: true

  validates :value, presence: true

private

  def turn_blanks_into_nils
    self.value = nil if value.blank?
  end

  def strip_extra_spaces
    self.value = value&.strip
  end
end
