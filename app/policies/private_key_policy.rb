# frozen_string_literal: true

class PrivateKeyPolicy < ApplicationPolicy
  def show?
    show_alert? && record.exist?
  end

  def show_alert?
    return false if account.nil?

    params[:private_key_pem_secret].present? &&
      (account.superuser? || account == record.account)
  end
end
