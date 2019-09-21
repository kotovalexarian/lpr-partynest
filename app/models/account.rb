# frozen_string_literal: true

class Account < ApplicationRecord
  NICKNAME_RE = /\A[a-z][a-z0-9]*(_[a-z0-9]+)*\z/.freeze

  ################
  # Associations #
  ################

  has_one_attached :avatar

  belongs_to :person, optional: true

  belongs_to :contact_list

  has_one :user

  has_many :sessions

  #############
  # Callbacks #
  #############

  after_initialize :generate_nickname

  before_validation :turn_blanks_into_nils
  before_validation :strip_extra_spaces

  ###############
  # Validations #
  ###############

  validates :person, allow_nil: true, uniqueness: true

  validates :contact_list, uniqueness: true

  validates :nickname,
            presence: true,
            length: { in: 3..36 },
            format: NICKNAME_RE,
            uniqueness: { case_sensitive: false }

  validates :public_name, allow_nil: true, length: { in: 1..255 }

  validates :biography, allow_nil: true, length: { in: 1..10_000 }

  validates :avatar, allow_nil: true, image: true

  validates :timezone, presence: true, timezone: true

  validate :contact_list_corresponds_person
  validate :person_corresponds_contact_list

  ###########
  # Methods #
  ###########

  def to_param
    nickname
  end

  def restricted?
    !superuser?
  end

  def can_access_sidekiq_web_interface?
    superuser?
  end

private

  def generate_nickname
    self.nickname ||= "noname_#{SecureRandom.hex(8)}"
  end

  def turn_blanks_into_nils
    self.public_name = nil if public_name.blank?
    self.biography   = nil if biography.blank?
  end

  def strip_extra_spaces
    self.public_name = public_name&.strip
    self.biography   = biography&.strip
  end

  def contact_list_corresponds_person
    return if person.nil?

    errors.add :contact_list unless contact_list == person.contact_list
  end

  def person_corresponds_contact_list
    return if contact_list.nil?

    errors.add :contact_list unless person == contact_list.person
  end
end
