# frozen_string_literal: true

class Settings::PeopleController < ApplicationController
  before_action :set_account

  # GET /settings/person
  def show
    authorize %i[settings person]
  end

private

  def set_account
    @account = current_account.clone&.reload
  end
end
