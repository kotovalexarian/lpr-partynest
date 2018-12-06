# frozen_string_literal: true

class MembershipPoolsController < ApplicationController
  # GET /membership_pools
  def index
    @membership_pools = policy_scope(MembershipPool)
  end
end
