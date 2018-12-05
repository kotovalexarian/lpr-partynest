# frozen_string_literal: true

class MembershipApplicationsController < ApplicationController
  # GET /membership_applications/new
  def new
    @membership_application = MembershipApplication.new

    authorize @membership_application
  end

  # POST /membership_applications
  def create
    @membership_application =
      MembershipApplication.new permitted_attributes MembershipApplication

    @membership_application.account = current_account || Account.new

    authorize @membership_application

    return render :new unless @membership_application.save

    remember_if_guest_account @membership_application.account

    redirect_to root_url
  end
end
