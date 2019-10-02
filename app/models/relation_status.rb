# frozen_string_literal: true

class RelationStatus < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :org_unit_kind, inverse_of: :relation_statuses

  ###############
  # Validations #
  ###############

  validates :codename, codename: true, uniqueness: { case_sensitive: false }

  validates :name, good_small_text: true, uniqueness: true

  ###########
  # Methods #
  ###########

  def to_param
    codename
  end
end
