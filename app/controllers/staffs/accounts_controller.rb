# frozen_string_literal: true

class Staffs::AccountsController < ApplicationController
  # GET /staff/accounts
  def index
    authorize %i[staff account]
    @accounts = policy_scope(
      Account,
      policy_scope_class: Staff::AccountPolicy::Scope,
    )
  end
end
