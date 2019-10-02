# frozen_string_literal: true

class Relationship < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :org_unit, inverse_of: :all_relationships

  belongs_to :parent_rel,
             class_name: 'Relationship',
             inverse_of: :children_rels,
             optional: true

  belongs_to :status, class_name: 'RelationStatus'

  belongs_to :person, inverse_of: :all_relationships

  has_many :children_rels,
           class_name: 'Relationship',
           inverse_of: :parent_rel,
           foreign_key: :parent_rel_id

  ###############
  # Validations #
  ###############

  validates :from_date,
            presence: true,
            uniqueness: { scope: %i[person_id org_unit_id] }

  #############
  # Callbacks #
  #############

  before_validation :set_level

private

  def set_level
    self.level = parent_rel.nil? ? 0 : parent_rel.level + 1
  end
end
