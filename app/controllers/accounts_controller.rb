# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :set_account

  # GET /accounts/:nickname
  def show
    authorize @account
  end

private

  def set_account
    @account = Account.find_by! nickname: params[:nickname]
  end
end
