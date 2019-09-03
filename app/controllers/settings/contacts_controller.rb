# frozen_string_literal: true

class Settings::ContactsController < ApplicationController
  before_action :skip_policy_scope, only: :index

  before_action :set_contact_list

  # GET /settings/contacts
  def index
    authorize %i[settings contact]
    @contacts = @contact_list.contacts
  end

private

  def set_contact_list
    @contact_list = current_account&.contact_list
  end
end
