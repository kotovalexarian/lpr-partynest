# frozen_string_literal: true

class RelationStatus < ApplicationRecord
  ################
  # Associations #
  ################

  has_many :transitions,
           class_name: 'RelationTransition',
           inverse_of: :from_status,
           foreign_key: :from_status_id,
           dependent: :restrict_with_exception

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
