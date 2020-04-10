# frozen_string_literal: true

class Settings::ContactPublicSwitchPolicy < ApplicationPolicy
  def create?
    account &&
      record.contact.contact_list.account == account
  end
end
