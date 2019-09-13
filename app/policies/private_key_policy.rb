# frozen_string_literal: true

class PrivateKeyPolicy < ApplicationPolicy
  def show?
    account&.superuser? &&
      record.exist? &&
      params[:private_key_pem_secret].present?
  end
end
