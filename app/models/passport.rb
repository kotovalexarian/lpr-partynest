# frozen_string_literal: true

class Passport < ApplicationRecord
  REQUIRED_CONFIRMATIONS = 3

  has_many_attached :images

  has_one :passport_map, dependent: :restrict_with_exception

  has_many :passport_confirmations, dependent: :restrict_with_exception

  accepts_nested_attributes_for :passport_map

  validates :confirmed,
            inclusion: { in: [false], unless: :enough_confirmations? }

  def image
    images.order(created_at: :desc).last
  end

  def enough_confirmations?
    passport_confirmations.count >= REQUIRED_CONFIRMATIONS
  end
end
