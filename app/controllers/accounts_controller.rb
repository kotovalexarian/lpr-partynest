# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :set_account

  # GET /accounts/:username
  def show
    authorize @account
  end

private

  def set_account
    @account = Account.find_by! username: params[:username]
  end
end
