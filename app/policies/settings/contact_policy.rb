# frozen_string_literal: true

class Settings::ContactPolicy < ApplicationPolicy
  def index?
    !!account
  end

  def create?
    !!account && record.contact_list.account == account
  end

  def destroy?
    !!account && record.contact_list.account == account
  end

  def permitted_attributes_for_create
    %i[contact_network_id value]
  end
end
