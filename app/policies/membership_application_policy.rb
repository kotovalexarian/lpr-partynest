# frozen_string_literal: true

class MembershipApplicationPolicy < ApplicationPolicy
  def create?
    true
  end
end
