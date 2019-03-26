# frozen_string_literal: true

class Passport < ApplicationRecord
  REQUIRED_CONFIRMATIONS = 3

  ################
  # Associations #
  ################

  belongs_to :person, optional: true

  has_many_attached :images

  has_many :passport_maps, dependent: :restrict_with_exception

  has_many :passport_confirmations, dependent: :restrict_with_exception

  accepts_nested_attributes_for :passport_maps, reject_if: :blank_passport_map?

  ###############
  # Validations #
  ###############

  validates :confirmed,
            inclusion: { in: [false], unless: :enough_confirmations? }

  validates :images, passport_image: true

  ###########
  # Methods #
  ###########

  def passport_map
    passport_maps.order(created_at: :asc).last
  end

  def image
    images.order(created_at: :asc).last
  end

  def can_have_confirmations?
    passport_map && image
  end

  def enough_confirmations?
    passport_confirmations.count >= REQUIRED_CONFIRMATIONS
  end

private

  def blank_passport_map?(passport_map_attributes)
    passport_map_attributes.all? do |key, value|
      next true if key.start_with? 'date_'

      value.blank?
    end
  end
end
