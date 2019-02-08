# frozen_string_literal: true

class Settings::RolesController < ApplicationController
  before_action :set_role, except: :index

  # GET /settings/roles
  def index
    authorize %i[settings role]

    @roles = policy_scope(
      current_account.roles,
      policy_scope_class: Settings::RolePolicy::Scope,
    )
  end

  # DELETE /settings/roles/:id
  def destroy
    authorize [:settings, @role]

    current_account.remove_role @role.name, @role.resource

    redirect_to settings_roles_url
  end

private

  def set_role
    @role = current_account.roles.find params[:id]
  end
end
