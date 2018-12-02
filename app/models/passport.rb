# frozen_string_literal: true

class Passport < ApplicationRecord
  REQUIRED_CONFIRMATIONS = 3

  has_many_attached :images

  has_many :passport_maps, dependent: :restrict_with_exception

  has_many :passport_confirmations, dependent: :restrict_with_exception

  accepts_nested_attributes_for :passport_maps

  validates :confirmed,
            inclusion: { in: [false], unless: :enough_confirmations? }

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
end
