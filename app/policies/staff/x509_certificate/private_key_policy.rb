# frozen_string_literal: true

class Staff::X509Certificate::PrivateKeyPolicy < ApplicationPolicy
  def show?
    return false if restricted?

    account&.superuser? &&
      record.exist? &&
      params[:private_key_secret].present?
  end
end
