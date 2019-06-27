# frozen_string_literal: true

class ContactsList < ApplicationRecord
  ################
  # Associations #
  ################

  has_one :account, dependent: :restrict_with_exception

  has_one :person, dependent: :restrict_with_exception
end
