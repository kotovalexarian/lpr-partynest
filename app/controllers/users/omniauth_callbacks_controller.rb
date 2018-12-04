# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  # GET|POST /resource/auth/:provider
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/:provider/callback
  # def failure
  #   super
  # end

  # GET|POST /users/auth/github/callback
  def github # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    auth = request.env['omniauth.auth']

    user = User.where(email: auth.info.email).first_or_create! do |new_user|
      new_user.password = Devise.friendly_token[0, 20]
    end

    UserOmniauth.where(
      provider:  auth.provider,
      remote_id: auth.uid,
    ).first_or_create! do |new_user_omniauth|
      new_user_omniauth.user = user
      new_user_omniauth.email = auth.info.email
    end

    sign_in_and_redirect user
  end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
