# frozen_string_literal: true

module UsersHelper
  def display_sign_in_link?
    controller_name != 'sessions'
  end

  def display_sign_up_link?
    devise_mapping.registerable? &&
      controller_name != 'registrations'
  end

  def display_password_reset_link?
    devise_mapping.recoverable? &&
      controller_name != 'passwords' &&
      controller_name != 'registrations'
  end

  def display_email_confirmation_link?
    devise_mapping.confirmable? &&
      controller_name != 'confirmations'
  end

  def display_unlock_link?
    devise_mapping.lockable? &&
      resource_class.unlock_strategy_enabled?(:email) &&
      controller_name != 'unlocks'
  end

  def display_omniauth_links?
    devise_mapping.omniauthable?
  end
end
