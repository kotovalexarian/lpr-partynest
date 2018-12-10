# frozen_string_literal: true

class Person < ApplicationRecord
  has_one :account, dependent: :restrict_with_exception
end
