# frozen_string_literal: true

class PrivateKeyPolicy < ApplicationPolicy
  def show?
    return false if account.nil?

    (account.superuser? || account == record.account) &&
      record.exist? &&
      params[:private_key_pem_secret].present?
  end
end
