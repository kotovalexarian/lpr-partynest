# frozen_string_literal: true

class MembershipApplicationsController < ApplicationController
  # GET /membership_applications/new
  def new
    @membership_application = MembershipApplication.new
  end
end
