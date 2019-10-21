# frozen_string_literal: true

class OrgUnit < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :kind,
             class_name: 'OrgUnitKind',
             inverse_of: :instances

  belongs_to :parent_unit,
             class_name: 'OrgUnit',
             inverse_of: :children_units,
             optional: true

  belongs_to :resource,
             polymorphic: true,
             optional: true

  has_many :children_units,
           class_name: 'OrgUnit',
           inverse_of: :parent_unit,
           foreign_key: :parent_unit_id

  has_many :all_relationships,
           class_name: 'Relationship',
           inverse_of: :org_unit

  ###############
  # Validations #
  ###############

  validates :short_name, good_small_text: true, uniqueness: true

  validates :name, good_small_text: true, uniqueness: true

  validates :parent_unit,
            presence: { if: :requires_parent?, message: :required },
            absence: { unless: :requires_parent? }

  validates :resource,
            presence: {
              if: ->(record) { record.kind&.resource_type },
              message: :required,
            }

  validate :parent_matches_kind

  #############
  # Callbacks #
  #############

  before_validation :set_level

  ###########
  # Methods #
  ###########

  def requires_parent?
    kind&.parent_kind
  end

private

  def parent_matches_kind
    errors.add :parent_unit unless parent_unit&.kind == kind&.parent_kind
  end

  def set_level
    self.level =
      if parent_unit.nil? then 0
      elsif parent_unit.level.nil? then nil
      else parent_unit.level + 1
      end
  end
end
