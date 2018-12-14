# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  prepend_before_action :check_captcha, only: :create

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    render_method_not_allowed
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

protected

  # The path used after sign up.
  def after_sign_up_path_for(_resource)
    super
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(_resource)
    super
  end

  # The default url to be used after updating a resource.
  def after_update_path_for(_resource)
    edit_user_registration_path
  end

  def check_captcha
    return if verify_recaptcha

    self.resource = resource_class.new sign_up_params
    resource.validate
    set_minimum_password_length
    render :new
  end
end
