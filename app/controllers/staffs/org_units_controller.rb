# frozen_string_literal: true

class Staffs::OrgUnitsController < ApplicationController
  include PaginalController

  before_action :set_org_unit, only: :show

  # GET /staff/org_units
  def index
    authorize [:staff, OrgUnit]
    @org_units = policy_scope(
      OrgUnit,
      policy_scope_class: Staff::OrgUnitPolicy::Scope,
    ).page(active_page)
  end

  # GET /staff/org_units/:id
  def show
    authorize [:staff, @org_unit]
  end

private

  def set_org_unit
    @org_unit = OrgUnit.find params[:id]
  end
end
