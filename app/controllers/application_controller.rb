# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception, prepend: true, unless: :json_request?

  before_action :set_raven_context
  before_action :sign_in_guest_account

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from Pundit::NotAuthorizedError,   with: :render_unauthorized

  helper_method :current_account

private

  def current_account
    @current_account ||= current_user&.account
    @current_account ||= Account.guests.find_by(id: session[:guest_account_id])
  end

  def pundit_user
    @pundit_user ||= ApplicationPolicy::Context.new(
      account:       current_account&.guest? ? nil : current_account,
      guest_account: current_account,
    )
  end

  def set_raven_context
    Raven.user_context(
      account_id: current_account&.id,
      user_id:    current_user&.id,
    )

    Raven.extra_context params: params.to_unsafe_h, url: request.url
  end

  def sign_in_guest_account
    return if current_account || params[:guest_token].blank?

    account = Account.guests.find_by! guest_token: params[:guest_token]
    remember_if_guest_account account
    redirect_to request.original_url
  end

  def json_request?
    request.format.json?
  end

  def render_not_found
    respond_to do |format|
      format.html { render status: :not_found, template: 'errors/not_found' }
      format.json { render status: :not_found, json: {} }
    end
  end

  def render_unauthorized
    render status: :unauthorized, json: {}
  end

  def render_method_not_allowed
    render status: :method_not_allowed, json: {}
  end

  def remember_if_guest_account(account)
    session[:guest_account_id] = account.id if account.guest?
  end
end
