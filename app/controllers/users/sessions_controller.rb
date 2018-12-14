# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  prepend_before_action :check_captcha, only: :create

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

protected

  def check_captcha
    return if verify_recaptcha

    self.resource = resource_class.new sign_in_params
    render :new
  end
end
