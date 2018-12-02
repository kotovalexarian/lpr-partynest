# frozen_string_literal: true

class PassportConfirmationsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_passport, only: :create

  # POST /passports/:passport_id/passport_confirmations
  def create
    ActiveRecord::Base.transaction do
      ConfirmPassport.call(passport: @passport,
                           account:  current_account).tap do |context|
        authorize_if_present context.passport_confirmation
      end
    end

    redirect_to @passport
  end

private

  def set_passport
    @passport = Passport.find params[:passport_id]
  end

  def authorize_if_present(record)
    if record
      authorize record
    else
      skip_authorization
    end
  end
end
