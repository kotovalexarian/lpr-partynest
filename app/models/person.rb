# frozen_string_literal: true

class Person < ApplicationRecord
  include Nameable

  ACCOUNT_CONNECTION_TOKEN_RE = /\A\w+\z/.freeze

  ################
  # Associations #
  ################

  has_one_attached :photo

  belongs_to :contact_list

  has_one :account

  has_many :all_relationships,
           -> { order(from_date: :asc) },
           class_name: 'Relationship',
           inverse_of: :person

  has_many :person_comments

  has_many :passports

  ###############
  # Validations #
  ###############

  validates :contact_list, uniqueness: true

  validates :photo, allow_nil: true, image: true

  validates :account_connection_token,
            allow_nil: true,
            allow_blank: false,
            length: { is: 32 },
            format: { with: ACCOUNT_CONNECTION_TOKEN_RE }

  ###########
  # Methods #
  ###########

  def full_name
    [
      last_name,
      first_name,
      middle_name,
    ].map(&:presence).compact.join(' ').freeze
  end

  def generate_account_connection_token
    update! account_connection_token: SecureRandom.alphanumeric(32)
  end
end
