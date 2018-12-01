# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  before_action :set_raven_context

  protect_from_forgery with: :exception, unless: :json_request?

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from NotAuthorizedError,           with: :unauthorized

private

  def set_raven_context
    Raven.user_context id: current_user.id if user_signed_in?
    Raven.extra_context params: params.to_unsafe_h, url: request.url
  end

  def json_request?
    request.format.json?
  end

  def not_found
    render status: :not_found, json: {}
  end

  def unauthorized
    render status: :unauthorized, json: {}
  end
end
