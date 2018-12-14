# frozen_string_literal: true

class MembershipAppsController < ApplicationController
  before_action :set_membership_app, only: :show
  before_action :verify_joined, only: :show
  before_action :verify_not_joined, only: :new

  # GET /membership_app
  def show
    authorize @membership_app
  end

  # GET /join
  def new
    @membership_app = MembershipApp.new

    authorize @membership_app
  end

  # POST /join
  def create
    @membership_app = MembershipApp.new permitted_attributes MembershipApp

    authorize @membership_app

    @membership_app.account = current_account || Account.new

    return render :new unless @membership_app.save

    ProcessNewMembershipApp.call membership_app: @membership_app

    remember_if_guest_account @membership_app.account

    redirect_to membership_app_url(
      guest_token: @membership_app.account.guest_token,
    )
  end

private

  def set_membership_app
    @membership_app = current_account&.own_membership_app
  end

  def verify_joined
    return if current_account&.own_membership_app

    skip_authorization
    redirect_to join_url
  end

  def verify_not_joined
    return if current_account&.own_membership_app.nil?

    skip_authorization
    redirect_to current_account.own_membership_app
  end
end
