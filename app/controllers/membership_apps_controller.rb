# frozen_string_literal: true

class MembershipAppsController < ApplicationController
  before_action :set_membership_app, only: :show

  # GET /membership_apps/:id
  def show
    authorize @membership_app
  end

  # GET /membership_apps/new
  def new
    @membership_app = MembershipApp.new

    authorize @membership_app
  end

  # POST /membership_apps
  def create
    @membership_app = MembershipApp.new permitted_attributes MembershipApp

    @membership_app.account = current_account || Account.new

    authorize @membership_app

    return render :new unless @membership_app.save

    ProcessNewMembershipApp.call membership_app: @membership_app

    remember_if_guest_account @membership_app.account

    redirect_to @membership_app
  end

private

  def set_membership_app
    @membership_app = MembershipApp.find params[:id]
  end
end
