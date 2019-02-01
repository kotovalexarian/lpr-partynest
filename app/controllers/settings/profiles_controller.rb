# frozen_string_literal: true

class Settings::ProfilesController < ApplicationController
  # GET /settings/profile/edit
  def edit
    authorize %i[settings profile]
  end
end
