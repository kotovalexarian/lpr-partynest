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
end
