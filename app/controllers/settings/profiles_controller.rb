# frozen_string_literal: true

class Settings::ProfilesController < ApplicationController
  # GET /settings/profile/edit
  def edit
    authorize %i[settings profile]
  end

  # PATCH/PUT /settings/profile
  def update
    authorize %i[settings profile]

    unless current_account.update account_attributes_for_update
      return render :edit
    end

    redirect_to edit_settings_profile_url
  end

private

  def account_attributes_for_update
    params.require(:account).permit(
      policy(%i[settings profile]).permitted_attributes_for_update,
    )
  end
end
