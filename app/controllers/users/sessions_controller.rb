# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # TODO: do not skip
  skip_after_action :verify_authorized, only: :create

  prepend_before_action :check_captcha, only: :create

  before_action :configure_sign_in_params, only: :create

  # GET /resource/sign_in
  def new
    authorize %i[users session]
    super
  end

  # POST /resource/sign_in
  def create
    super do |user|
      LogUserSessionJob.perform_later user.id, request.user_agent
    end
  end

  # DELETE /resource/sign_out
  def destroy
    authorize %i[users session]
    super
  end

protected

  def check_captcha
    return if verify_captcha

    self.resource = resource_class.new sign_in_params
    render :new
  end

  def verify_signed_out_user
    super if current_account.nil?
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[otp_attempt])
  end
end
