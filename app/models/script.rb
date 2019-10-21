# frozen_string_literal: true

class Script < ApplicationRecord
  ###############
  # Validations #
  ###############

  validates :codename, codename: true, uniqueness: { case_sensitive: false }

  validates :name, good_small_text: true, uniqueness: true

  validates :source_code, presence: true

  ###########
  # Methods #
  ###########

  def to_param
    codename
  end
end
