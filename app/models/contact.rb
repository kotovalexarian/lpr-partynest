# frozen_string_literal: true

class Contact < ApplicationRecord
  delegate :communicable?,
           to: :contact_network,
           allow_nil: true,
           prefix: true

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

  validates :value,
            presence: true,
            uniqueness: { scope: %i[contact_list_id contact_network_id] }

  validates :send_security_notifications,
            inclusion: { in: [false], unless: :contact_network_communicable? }

private

  def turn_blanks_into_nils
    self.value = nil if value.blank?
  end

  def strip_extra_spaces
    self.value = value&.strip
  end
end
