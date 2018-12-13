# frozen_string_literal: true

class Staff::MembershipAppsController < ApplicationController
  before_action :set_membership_app, except: :index

  # GET /membership_apps
  def index
    authorize %i[staff membership_app]
    @membership_apps = policy_scope(
      MembershipApp,
      policy_scope_class: Staff::MembershipAppPolicy::Scope,
    )
  end

  # GET /membership_apps/:id
  def show
    authorize [:staff, @membership_app]
  end

private

  def set_membership_app
    @membership_app = MembershipApp.find params[:id]
  end
end
