# frozen_string_literal: true

class Settings::PassportsController < ApplicationController
  include PaginalController

  before_action :skip_policy_scope, only: :index

  before_action :set_account
  before_action :set_passport, only: :show

  # GET /settings/passports
  def index
    authorize [:settings, Passport]

    @passports = @account.person.passports.page(active_page)
  end

  # GET /settings/passports/:id
  def show
    authorize [:settings, @passport]
  end

private

  def set_account
    @account = current_account.clone&.reload
  end

  def set_passport
    @passport = Passport.find params[:id]
  end
end
