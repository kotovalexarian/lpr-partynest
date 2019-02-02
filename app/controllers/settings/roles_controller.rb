# frozen_string_literal: true

class Settings::RolesController < ApplicationController
  # GET /settings/roles
  def index
    authorize %i[settings role]

    @roles = policy_scope(
      current_account.roles,
      policy_scope_class: Settings::RolePolicy::Scope,
    )
  end
end
