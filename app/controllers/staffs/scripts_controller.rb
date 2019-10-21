# frozen_string_literal: true

class Staffs::ScriptsController < ApplicationController
  before_action :set_script, only: :show

  # GET /staff/scripts
  def index
    authorize [:staff, Script]
    @scripts = policy_scope(
      Script.order(codename: :asc),
      policy_scope_class: Staff::ScriptPolicy::Scope,
    ).page(params[:page])
  end

  # GET /staff/scripts/:codename
  def show
    authorize [:staff, @script]
  end

private

  def set_script
    @script = Script.find_by! codename: params[:codename]
  end
end
