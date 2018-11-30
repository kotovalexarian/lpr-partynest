# frozen_string_literal: true

class PassportConfirmationsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_passport, only: :create

  # POST /passports/:passport_id/passport_confirmations
  def create
    authorize @passport.passport_confirmations.build user: current_user

    return redirect_to @passport unless @passport.save

    redirect_to @passport
  end

private

  def set_passport
    @passport = Passport.find params[:passport_id]
  end
end
