# frozen_string_literal: true

class Staffs::AccountsController < ApplicationController
  before_action :set_account, except: :index

  # GET /staff/accounts
  def index
    authorize [:staff, Account]
    @accounts = policy_scope(
      Account,
      policy_scope_class: Staff::AccountPolicy::Scope,
    )
  end

  # GET /staff/accounts/:nickname
  def show
    authorize [:staff, @account]
  end

private

  def set_account
    @account = Account.find_by! nickname: params[:nickname]
  end
end
