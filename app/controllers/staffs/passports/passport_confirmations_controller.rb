# frozen_string_literal: true

class Staffs::Passports::PassportConfirmationsController < ApplicationController
  before_action :authenticate_user!, only: :create

  before_action :set_passport, only: %i[index create]

  # GET /staff/passports/:passport_id/passport_confirmations
  def index
    @passport_confirmations = policy_scope(
      @passport.passport_confirmations,
      policy_scope_class: Staff::PassportConfirmationPolicy::Scope,
    )
  end

  # POST /staff/passports/:passport_id/passport_confirmations
  def create
    ActiveRecord::Base.transaction do
      ConfirmPassport.call(passport: @passport,
                           account:  current_account).tap do |context|
        authorize_if_present context.passport_confirmation
      end
    end

    redirect_to staff_passport_passport_confirmations_path @passport
  end

private

  def set_passport
    @passport = Passport.find params[:passport_id]
  end

  def authorize_if_present(record)
    if record
      authorize [:staff, record]
    else
      skip_authorization
    end
  end
end
