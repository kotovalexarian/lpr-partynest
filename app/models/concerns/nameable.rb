# frozen_string_literal: true

module Nameable
  extend ActiveSupport::Concern

  included do
    pg_enum :sex, %i[male female]

    before_validation :turn_blank_middle_name_into_nil

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :sex, presence: true
    validates :date_of_birth, presence: true
    validates :place_of_birth, presence: true
  end

  def turn_blank_middle_name_into_nil
    self.middle_name = nil if middle_name.blank?
  end
end
