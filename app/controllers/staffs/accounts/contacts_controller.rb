# frozen_string_literal: true

class Staffs::Accounts::ContactsController < ApplicationController
  include PaginalController

  before_action :set_account

  # GET /staff/accounts/:account_nickname/contacts
  def index
    authorize [:staff, Account, Contact]

    @contacts = policy_scope(
      @account.contact_list.contacts,
      policy_scope_class: Staff::Account::ContactPolicy::Scope,
    ).page(active_page)
  end

private

  def set_account
    @account = Account.find_by! nickname: params[:account_nickname]
  end
end
