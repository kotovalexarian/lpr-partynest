# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # TODO: do not skip
  skip_after_action :verify_authorized, only: %i[create destroy]

  prepend_before_action :check_captcha, only: :create

  # GET /resource/sign_up
  def new
    authorize %i[users registration]
    super
  end

  # POST /resource
  def create
    authorize %i[users registration]
    super
  end

  # GET /resource/edit
  def edit
    authorize %i[users registration]
    super
  end

  # PUT /resource
  def update
    authorize %i[users registration]
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
    authorize %i[users registration]
    super
  end

protected

  # Build a devise resource passing in the session.
  # Useful to move temporary session data to the newly created user.
  def build_resource(hash = {})
    super
    resource.account ||= current_account if current_account&.user.nil?
    resource.account ||= Account.new contact_list: ContactList.new
  end

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
    return if verify_captcha

    self.resource = resource_class.new sign_up_params
    resource.validate
    set_minimum_password_length
    render :new
  end
end
