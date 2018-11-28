# frozen_string_literal: true

class MembershipApplicationsController < ApplicationController
  CREATE_ATTRIBUTES = %i[
    first_name
    last_name
    middle_name
    date_of_birth
    occupation
    email
    phone_number
    telegram_username
    organization_membership
    comment
  ].freeze

  # GET /membership_applications/new
  def new
    @membership_application = MembershipApplication.new
  end

  # POST /membership_applications
  def create
    @membership_application = MembershipApplication.new create_params

    return render :new unless @membership_application.save

    redirect_to root_url
  end

private

  def create_params
    params.require(:membership_application).permit(CREATE_ATTRIBUTES)
  end
end
