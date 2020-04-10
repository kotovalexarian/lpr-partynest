# frozen_string_literal: true

class Settings::PassportsController < ApplicationController
  include PaginalController

  before_action :skip_policy_scope, only: :index

  before_action :set_account

  # GET /settings/passports
  def index
    authorize [:settings, Passport]

    @passports = @account.person.passports.page(active_page)
  end

private

  def set_account
    @account = current_account.clone&.reload
  end
end
