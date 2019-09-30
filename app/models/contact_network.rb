# frozen_string_literal: true

class ContactNetwork < ApplicationRecord
  ################
  # Associations #
  ################

  has_many :contacts

  ###############
  # Validations #
  ###############

  validates :codename, codename: true, uniqueness: { case_sensitive: false }

  validates :name, good_small_text: true

  ###########
  # Methods #
  ###########

  def to_param
    codename
  end

  def communicable?
    %w[email telegram_id].include? codename
  end
end
