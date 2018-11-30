# frozen_string_literal: true

class Passport < ApplicationRecord
  REQUIRED_CONFIRMATIONS = 3

  enum sex: %i[male female]

  has_one_attached :image

  has_many :passport_confirmations, dependent: :restrict_with_exception

  validates :surname, presence: true
  validates :given_name, presence: true
  validates :sex, presence: true
  validates :date_of_birth, presence: true
  validates :place_of_birth, presence: true
  validates :series, presence: true
  validates :number, presence: true
  validates :issued_by, presence: true
  validates :unit_code, presence: true
  validates :date_of_issue, presence: true

  validate do
    errors.add :image, :blank unless image.attached?
  end

  before_validation do
    self.patronymic = nil if patronymic.blank?
  end

  before_save do
    next unless passport_confirmations.length >= REQUIRED_CONFIRMATIONS

    self.confirmed = true
  end
end
