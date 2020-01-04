# frozen_string_literal: true

class Staffs::ContactNetworksController < ApplicationController
  # GET /staff/contact_networks
  def index
    authorize [:staff, ContactNetwork]
    @contact_networks = policy_scope(
      ContactNetwork.order(codename: :asc),
      policy_scope_class: Staff::ContactNetworkPolicy::Scope,
    ).page(params[:page])
  end
end
