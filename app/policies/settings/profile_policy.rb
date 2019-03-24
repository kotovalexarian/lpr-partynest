# frozen_string_literal: true

class Settings::ProfilePolicy < ApplicationPolicy
  def update?
    account && !account.guest?
  end

  def permitted_attributes_for_update
    %i[nickname public_name biography avatar]
  end
end
