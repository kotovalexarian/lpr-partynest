# frozen_string_literal: true

class OrgUnitKind < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :parent_kind,
             class_name: 'OrgUnitKind',
             inverse_of: :children_kinds,
             optional: true

  has_many :children_kinds,
           class_name: 'OrgUnitKind',
           inverse_of: :parent_kind,
           foreign_key: :parent_kind_id

  has_many :instances,
           class_name: 'OrgUnit',
           inverse_of: :kind,
           foreign_key: :kind_id

  ###############
  # Validations #
  ###############

  validates :codename, codename: true, uniqueness: { case_sensitive: false }

  validates :short_name, good_small_text: true, uniqueness: true

  validates :name, good_small_text: true, uniqueness: true

  #############
  # Callbacks #
  #############

  before_validation :set_level

  ###########
  # Methods #
  ###########

  def to_param
    codename
  end

private

  def set_level
    self.level = parent_kind.nil? ? 0 : parent_kind.level + 1
  end
end
