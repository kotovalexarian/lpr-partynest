# frozen_string_literal: true

class Person < ApplicationRecord
  belongs_to :regional_office

  has_one :account, dependent: :restrict_with_exception
end
