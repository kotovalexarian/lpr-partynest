# frozen_string_literal: true

class MembershipPoolsController < ApplicationController
  before_action :set_membership_pool, except: :index

  # GET /membership_pools
  def index
    @membership_pools = policy_scope(MembershipPool)
  end

  # GET /membership_pools
  def show
    authorize @membership_pool
  end

private

  def set_membership_pool
    @membership_pool = MembershipPool.find params[:id]
  end
end
