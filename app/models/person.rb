# frozen_string_literal: true

class Person < ApplicationRecord
  belongs_to :regional_office

  has_one :account, dependent: :restrict_with_exception

  has_one :own_membership_app,
          class_name: 'MembershipApp',
          inverse_of: :person,
          through:    :account,
          source:     :own_membership_app

  def related_to_party?
    party_supporter? || party_member? || excluded_from_party?
  end

  def party_supporter?
    false
  end

  def party_member?
    true
  end

  def excluded_from_party?
    false
  end
end
