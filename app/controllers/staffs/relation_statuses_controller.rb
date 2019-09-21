# frozen_string_literal: true

class Staffs::RelationStatusesController < ApplicationController
  # GET /staff/relation_statuses
  def index
    authorize [:staff, RelationStatus]
    @relation_statuses = policy_scope(
      RelationStatus.order(codename: :asc),
      policy_scope_class: Staff::RelationStatusPolicy::Scope,
    ).page(params[:page])
  end
end
