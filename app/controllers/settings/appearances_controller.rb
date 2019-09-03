# frozen_string_literal: true

class Settings::AppearancesController < ApplicationController
  before_action :set_account

  # GET /settings/appearance/edit
  def edit
    authorize %i[settings appearance]
  end

  # PATCH/PUT /settings/appearance
  def update
    authorize %i[settings appearance]

    return render :edit unless @account.update account_attributes_for_update

    redirect_to edit_settings_appearance_url, notice: translate_flash
  end

private

  def set_account
    @account = current_account.clone&.reload
  end

  def account_attributes_for_update
    params.require(:account).permit(
      policy(%i[settings appearance]).permitted_attributes_for_update,
    )
  end
end
