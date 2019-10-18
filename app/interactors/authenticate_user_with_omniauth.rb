# frozen_string_literal: true

class AuthenticateUserWithOmniauth
  include Interactor

  def call
    validate_context

    ActiveRecord::Base.transaction do
      build_user
      build_user_omniauth
      validity_check
      security_check
      save_records
    end
  end

private

  def validate_context
    return if context.provider.present? &&
              context.remote_id.present? &&
              context.email.present?

    context.fail! user: nil, user_omniauth: nil
  end

  def build_user
    context.user = User.where(
      email: context.email,
    ).lock(true).first_or_initialize do |new_user|
      new_user.account = Account.new contact_list: ContactList.new
      new_user.password = Devise.friendly_token User::MAX_PASSWORD_LENGTH
    end
  end

  def build_user_omniauth
    context.user_omniauth = UserOmniauth.where(
      provider: context.provider,
      remote_id: context.remote_id,
    ).lock(true).first_or_initialize do |new_user_omniauth|
      new_user_omniauth.user = context.user
      new_user_omniauth.email = context.email
    end
  end

  def validity_check
    return if context.user_omniauth.user == context.user

    context.fail! user: nil, user_omniauth: nil
  end

  def security_check
    return unless context.user.persisted? && context.user_omniauth.new_record?

    context.fail! user: nil, user_omniauth: nil
  end

  def save_records
    return if context.user.save &&
              context.user_omniauth.save

    context.fail! user: nil, user_omniauth: nil
  end
end
