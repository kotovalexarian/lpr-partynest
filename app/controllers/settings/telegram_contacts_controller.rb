# frozen_string_literal: true

class Settings::TelegramContactsController < ApplicationController
  # GET /settings/telegram_contacts
  def index
    authorize %i[settings account_telegram_contact]

    @telegram_contacts = policy_scope(
      current_account.account_telegram_contacts,
      policy_scope_class: Settings::AccountTelegramContactPolicy::Scope,
    )
  end
end
