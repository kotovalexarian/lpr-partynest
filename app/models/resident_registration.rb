# frozen_string_literal: true

class ResidentRegistration < ApplicationRecord
  belongs_to :person, optional: true
end
