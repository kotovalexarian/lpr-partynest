# frozen_string_literal: true

class Settings::ContactsController < ApplicationController
  before_action :skip_policy_scope, only: :index

  before_action :set_account

  # GET /settings/contacts
  def index
    authorize %i[settings contact]
    @contacts = @account.contact_list.contacts
  end

private

  def set_account
    @account = current_account.clone&.reload
  end
end
