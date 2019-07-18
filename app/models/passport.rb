# frozen_string_literal: true

class Passport < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :person, optional: true

  has_many :passport_maps,
           dependent: :restrict_with_exception

  accepts_nested_attributes_for :passport_maps,
                                reject_if: :blank_passport_map?

  ###########
  # Methods #
  ###########

  def passport_map
    passport_maps.order(created_at: :asc).last
  end

private

  def blank_passport_map?(passport_map_attributes)
    passport_map_attributes.all? do |key, value|
      next true if key.start_with? 'date_'

      value.blank?
    end
  end
end
