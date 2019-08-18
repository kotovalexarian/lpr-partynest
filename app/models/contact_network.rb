# frozen_string_literal: true

class ContactNetwork < ApplicationRecord
  CODENAME_RE = /\A[a-z][a-z0-9]*(_[a-z0-9]+)*\z/.freeze

  ################
  # Associations #
  ################

  has_many :contacts, dependent: :restrict_with_exception

  #############
  # Callbacks #
  #############

  before_validation :turn_blanks_into_nils
  before_validation :strip_extra_spaces

  ###############
  # Validations #
  ###############

  validates :codename,
            presence: true,
            length: { in: 3..36 },
            format: CODENAME_RE,
            uniqueness: { case_sensitive: false }

  validates :name, allow_nil: true, length: { in: 1..255 }

  ###########
  # Methods #
  ###########

  def to_param
    codename
  end

private

  def turn_blanks_into_nils
    self.codename = nil if codename.blank?
    self.name     = nil if name.blank?
  end

  def strip_extra_spaces
    self.codename = codename&.strip
    self.name     = name&.strip
  end
end
