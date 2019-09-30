# frozen_string_literal: true

class Staffs::OrgUnitKindsController < ApplicationController
  # GET /staff/org_unit_kinds
  def index
    authorize [:staff, OrgUnitKind]
    @org_unit_kinds = policy_scope(
      OrgUnitKind.order(codename: :asc),
      policy_scope_class: Staff::OrgUnitKindPolicy::Scope,
    ).page(params[:page])
  end
end
