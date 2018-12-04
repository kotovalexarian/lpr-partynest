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
  def github # rubocop:disable Metrics/AbcSize
    auth = request.env['omniauth.auth']

    users = User.where omniauth_provider: auth.provider, omniauth_uid: auth.uid

    user = users.first_or_create do |new_user|
      new_user.omniauth_provider = auth.provider
      new_user.omniauth_uid      = auth.uid
      new_user.email             = auth.info.email
      new_user.password          = Devise.friendly_token[0, 20]
    end

    sign_in_and_redirect user
  end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
