# frozen_string_literal: true

class Settings::SessionsController < ApplicationController
  before_action :skip_policy_scope, only: :index

  # GET /settings/sessions
  def index
    authorize [:settings, Session]

    @sessions = current_account.sessions.order(logged_at: :desc)
                               .page(params[:page])
  end
end
