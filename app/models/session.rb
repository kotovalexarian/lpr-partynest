# frozen_string_literal: true

class Session < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :account

  #############
  # Callbacks #
  #############

  before_validation :turn_nils_into_blanks
  before_validation :strip_extra_spaces

  ###############
  # Validations #
  ###############

  validates :logged_at, presence: true

  validates :ip_address, presence: true

  validates :user_agent, allow_nil: true, good_big_text: true

private

  def turn_nils_into_blanks
    self.user_agent = nil if user_agent.blank?
  end

  def strip_extra_spaces
    self.user_agent = user_agent&.strip
  end
end
