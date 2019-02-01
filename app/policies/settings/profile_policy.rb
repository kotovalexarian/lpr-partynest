# frozen_string_literal: true

class Settings::ProfilePolicy < ApplicationPolicy
  def update?
    account && !account.guest?
  end

  def permitted_attributes_for_update
    %i[username public_name biography]
  end
end
