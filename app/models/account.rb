# frozen_string_literal: true

class Account < ApplicationRecord
  NICKNAME_RE = /\A[a-z][a-z0-9]*(_[a-z0-9]+)*\z/.freeze

  ##########
  # Scopes #
  ##########

  scope :guests, -> { includes(:user).where(users: { id: nil }) }

  ################
  # Associations #
  ################

  has_one_attached :avatar

  belongs_to :person, optional: true

  belongs_to :contact_list

  has_one :user

  #############
  # Callbacks #
  #############

  after_initialize :generate_nickname

  before_validation do
    self.contact_list ||= person ? person.contact_list : ContactList.new
  end

  before_validation :turn_blanks_into_nils
  before_validation :strip_extra_spaces

  before_create :generate_guest_token

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

  validate :contact_list_corresponds_person

  ###########
  # Methods #
  ###########

  def to_param
    nickname
  end

  def guest?
    user.nil?
  end

  def can_access_sidekiq_web_interface?
    superuser?
  end

  def can_initiate_relationship?(regional_office)
    return false if regional_office.nil?
    return true if superuser?

    current_relationship = person&.current_relationship
    return false if current_relationship.nil?

    current_relationship.federal_secretary? ||
      current_relationship.regional_secretary? &&
        current_relationship.regional_office == regional_office
  end

private

  def generate_nickname
    self.nickname ||= "noname_#{SecureRandom.hex(8)}"
  end

  def generate_guest_token
    self.guest_token ||= SecureRandom.hex
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
end
