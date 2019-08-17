# frozen_string_literal: true

class Staffs::ContactNetworksController < ApplicationController
  # GET /staff/contact_networks
  def index
    authorize %i[staff contact_network]
    @contact_networks = policy_scope(
      ContactNetwork,
      policy_scope_class: Staff::ContactNetworkPolicy::Scope,
    )
  end
end
