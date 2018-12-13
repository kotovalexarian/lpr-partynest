# frozen_string_literal: true

class Staff::PassportsController < ApplicationController
  before_action :set_passport, except: %i[index new create]

  # GET /passports
  def index
    @passports = policy_scope(
      Passport,
      policy_scope_class: Staff::PassportPolicy::Scope,
    )
  end

  # GET /passports/:id
  def show
    authorize [:staff, @passport]
    @passport.passport_maps.build if @passport.passport_map.nil?
  end

  # GET /passports/new
  def new
    @passport = Passport.new
    @passport.passport_maps.build

    authorize [:staff, @passport]
  end

  # POST /passports
  def create
    @passport = Passport.new permitted_attributes [:staff, Passport]

    authorize [:staff, @passport]

    return render :new unless @passport.save

    redirect_to [:staff, @passport]
  end

private

  def set_passport
    @passport = Passport.find params[:id]
  end
end
