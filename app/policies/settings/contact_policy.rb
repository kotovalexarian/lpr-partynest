# frozen_string_literal: true

class Settings::ContactPolicy < ApplicationPolicy
  def index?
    !!account
  end

  def destroy?
    !!account && record.contact_list.account == account
  end
end
