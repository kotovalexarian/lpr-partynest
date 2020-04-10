# frozen_string_literal: true

class Settings::PassportsController < ApplicationController
  include PaginalController

  before_action :skip_policy_scope, only: :index

  before_action :set_account
  before_action :set_passport,   only: :show
  before_action :new_passport,   only: :new
  before_action :build_passport, only: :create

  # GET /settings/passports
  def index
    authorize [:settings, Passport]

    @passports = @account.person.passports.page(active_page)
  end

  # GET /settings/passports/:id
  def show
    authorize [:settings, @passport]
  end

  # GET /settings/passports/new
  def new
    authorize [:settings, Passport]
  end

  # POST /settings/passports
  def create
    authorize [:settings, @passport]

    return render :new unless @passport.save

    redirect_to [:settings, @passport]
  end

private

  def set_account
    @account = current_account.clone&.reload
  end

  def set_passport
    @passport = Passport.find params[:id]
  end

  def new_passport
    @passport = Passport.new person: @account&.person
  end

  def build_passport
    @passport = Passport.new permitted_attributes [:settings, Passport]
    @passport.person = @account&.person
  end
end
