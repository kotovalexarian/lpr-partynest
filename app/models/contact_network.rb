# frozen_string_literal: true

class ContactNetwork < ApplicationRecord
  FORMAT_RE = /\A[^[:space:]]+(.*[^[:space:]]+)?\z/.freeze

  ################
  # Associations #
  ################

  has_many :contacts

  ###############
  # Validations #
  ###############

  validates :codename,
            presence: true,
            codename: true,
            uniqueness: { case_sensitive: false }

  validates :name,
            presence: true,
            length: { in: 1..255 },
            format: FORMAT_RE

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
