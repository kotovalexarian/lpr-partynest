# frozen_string_literal: true

class Relationship < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :person, inverse_of: :all_relationships

  belongs_to :regional_office

  belongs_to :initiator_account,
             class_name: 'Account',
             inverse_of: false,
             optional: true

  ###############
  # Validations #
  ###############

  validates :from_date, presence: true, uniqueness: { scope: :person_id }
end
