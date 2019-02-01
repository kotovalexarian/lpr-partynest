# frozen_string_literal: true

class Settings::ProfilesController < ApplicationController
  before_action :set_account

  # GET /settings/profile/edit
  def edit
    authorize %i[settings profile]
  end

  # PATCH/PUT /settings/profile
  def update
    authorize %i[settings profile]

    return render :edit unless @account.update account_attributes_for_update

    redirect_to edit_settings_profile_url
  end

private

  def set_account
    @account = current_account.clone&.reload
  end

  def account_attributes_for_update
    params.require(:account).permit(
      policy(%i[settings profile]).permitted_attributes_for_update,
    )
  end
end
