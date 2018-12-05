# frozen_string_literal: true

class MembershipApplicationsController < ApplicationController
  before_action :set_membership_application, only: :show

  # GET /membership_applications/:id
  def show
    authorize @membership_application
  end

  # GET /membership_applications/new
  def new
    @membership_application = MembershipApplication.new

    authorize @membership_application
  end

  # POST /membership_applications
  def create
    @membership_application =
      MembershipApplication.new permitted_attributes MembershipApplication

    @membership_application.account = guest_account || Account.new

    authorize @membership_application

    return render :new unless @membership_application.save

    remember_if_guest_account @membership_application.account

    redirect_to @membership_application
  end

private

  def set_membership_application
    @membership_application = MembershipApplication.find params[:id]
  end
end
