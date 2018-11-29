# frozen_string_literal: true

class ApplicationController < ActionController::Base
  class NotAuthorizedError < RuntimeError; end

  skip_before_action :verify_authenticity_token, if: :json_request?

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from NotAuthorizedError,           with: :unauthorized

private

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
