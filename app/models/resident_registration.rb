# frozen_string_literal: true

class ResidentRegistration < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :person, optional: true
end
