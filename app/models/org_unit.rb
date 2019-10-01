# frozen_string_literal: true

class OrgUnit < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :kind,
             class_name: 'OrgUnitKind',
             inverse_of: :instances

  belongs_to :parent,
             class_name: 'OrgUnit',
             inverse_of: :children,
             optional: true

  has_many :children,
           class_name: 'OrgUnit',
           inverse_of: :parent,
           foreign_key: :parent_id

  has_many :all_relationships,
           class_name: 'Relationship',
           inverse_of: :org_unit

  ###############
  # Validations #
  ###############

  validates :short_name, good_small_text: true, uniqueness: true

  validates :name, good_small_text: true, uniqueness: true

  validates :parent,
            presence: {
              if: ->(record) { record.kind&.parent_kind },
              message: :required,
            }

  validate :parent_matches_kind

private

  def parent_matches_kind
    errors.add :parent unless parent&.kind == kind&.parent_kind
  end
end
