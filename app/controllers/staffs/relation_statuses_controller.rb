# frozen_string_literal: true

class Staffs::RelationStatusesController < ApplicationController
  before_action :set_relation_status, only: :show

  # GET /staff/relation_statuses
  def index
    authorize [:staff, RelationStatus]
    @relation_statuses = policy_scope(
      RelationStatus.order(codename: :asc),
      policy_scope_class: Staff::RelationStatusPolicy::Scope,
    ).page(params[:page])
  end

  # GET /staff/relation_statuses/:codename
  def show
    authorize [:staff, @relation_status]
  end

private

  def set_relation_status
    @relation_status = RelationStatus.find_by! codename: params[:codename]
  end
end
