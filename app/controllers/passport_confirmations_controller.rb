# frozen_string_literal: true

class PassportConfirmationsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_passport, only: :create

  # POST /passports/:passport_id/passport_confirmations
  def create
    @passport_confirmation = PassportConfirmation.new(
      passport: @passport,
      user:     current_user,
    )

    authorize @passport_confirmation

    return redirect_to @passport unless @passport_confirmation.save

    redirect_to @passport
  end

private

  def set_passport
    @passport = Passport.find params[:passport_id]
  end
end
