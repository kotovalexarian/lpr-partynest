# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # TODO: do not skip
  skip_after_action :verify_authorized, only: :create

  prepend_before_action :check_captcha, only: :create

  # GET /resource/sign_in
  def new
    authorize %i[users session]
    super
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  def destroy
    authorize %i[users session]
    super do
      set_flash_message! :notice, :signed_out if current_account&.guest?
      session[:guest_account_id] = nil
    end
  end

protected

  def check_captcha
    return if verify_recaptcha

    self.resource = resource_class.new sign_in_params
    render :new
  end

  def verify_signed_out_user
    super if current_account.nil?
  end
end
