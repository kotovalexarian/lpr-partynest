# frozen_string_literal: true

class PassportsController < ApplicationController
  before_action :set_passport, except: %i[index new create]

  # GET /passports
  def index
    @passports = policy_scope(Passport)
  end

  # GET /passports/:id
  def show
    authorize @passport
  end

  # GET /passports/new
  def new
    @passport = Passport.new
    authorize @passport
  end

private

  def set_passport
    @passport = Passport.find params[:id]
  end
end
