# frozen_string_literal: true

class ContactsList < ApplicationRecord
  ################
  # Associations #
  ################

  has_one :account

  has_one :person
end
