# frozen_string_literal: true

class Person < ApplicationRecord
  include Nameable
  include Searchable

  ACCOUNT_CONNECTION_TOKEN_RE = /\A\w+\z/.freeze

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :first_name,     analyzer: 'russian'
      indexes :middle_name,    analyzer: 'russian'
      indexes :last_name,      analyzer: 'russian'
      indexes :place_of_birth, analyzer: 'russian'
    end
  end

  ################
  # Associations #
  ################

  has_one_attached :photo

  belongs_to :contact_list

  has_one :account

  has_many :all_relationships,
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

  def destroy_account_connection_token
    update! account_connection_token: nil
  end
end
