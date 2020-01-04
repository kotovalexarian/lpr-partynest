# frozen_string_literal: true

class Staffs::OrgUnitKindsController < ApplicationController
  include PaginalController

  before_action :set_org_unit_kind, only: :show

  # GET /staff/org_unit_kinds
  def index
    authorize [:staff, OrgUnitKind]
    @org_unit_kinds = policy_scope(
      OrgUnitKind.order(codename: :asc),
      policy_scope_class: Staff::OrgUnitKindPolicy::Scope,
    ).page(active_page)
  end

  # GET /staff/org_unit_kinds/:codename
  def show
    authorize [:staff, @org_unit_kind]
  end

private

  def set_org_unit_kind
    @org_unit_kind = OrgUnitKind.find_by! codename: params[:codename]
  end
end
