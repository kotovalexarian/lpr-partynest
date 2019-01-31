# frozen_string_literal: true

class InitializeTelegramBot
  include Interactor

  include Rails.application.routes.url_helpers

  def call
    fetch_info
    set_webhook
  end

private

  def fetch_info
    user = context.telegram_bot.client.get_me
    context.telegram_bot.update! username: user.username
  rescue Telegram::Bot::Error, ActiveRecord::RecordInvalid
    context.fail!
  end

  def set_webhook
    context.telegram_bot.client.set_webhook(
      url:             webhook_url,
      max_connections: 1,
    )
  rescue Telegram::Bot::Error
    context.fail!
  end

  def webhook_url
    callbacks_telegram_bot_updates_url(
      context.telegram_bot,
      format:   'json',
      protocol: 'https',
      host:     Rails.application.config.site_domain,
      secret:   context.telegram_bot.secret,
    )
  end
end
