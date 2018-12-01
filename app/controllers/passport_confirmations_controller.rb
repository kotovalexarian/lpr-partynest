# frozen_string_literal: true

class PassportConfirmationsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_passport, only: :create

  # POST /passports/:passport_id/passport_confirmations
  def create
    ActiveRecord::Base.transaction do
      ConfirmPassport.call(passport: @passport,
                           user:     current_user).tap do |context|
        authorize context.passport_confirmation
      end
    end

    redirect_to @passport
  end

private

  def set_passport
    @passport = Passport.find params[:passport_id]
  end
end
