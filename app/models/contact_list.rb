# frozen_string_literal: true

class ContactList < ApplicationRecord
  ################
  # Associations #
  ################

  has_one :account

  has_one :person
end
