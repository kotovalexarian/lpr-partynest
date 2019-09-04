# frozen_string_literal: true

class Settings::ContactSecurityNotificationSwitchPolicy < ApplicationPolicy
  def create?
    account &&
      record.contact.contact_list.account == account &&
      record.contact.contact_network_communicable?
  end
end
