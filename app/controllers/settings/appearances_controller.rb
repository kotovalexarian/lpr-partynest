# frozen_string_literal: true

class Settings::AppearancesController < ApplicationController
  before_action :set_account

  # GET /settings/appearance/edit
  def edit
    authorize %i[settings appearance]
  end

private

  def set_account
    @account = current_account.clone&.reload
  end
end
