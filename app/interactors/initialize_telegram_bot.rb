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
    data = call_api_method_get :getMe

    context.fail! unless data['ok'] && context.telegram_bot.update(
      username: data['result']['username'],
    )
  end

  def set_webhook
    data = call_api_method_get(
      :setWebhook,
      max_connections: 1,
      url:             webhook_url,
    )

    context.fail! unless data['ok']
  end

  def api_method_url(method)
    "https://api.telegram.org/bot#{context.telegram_bot.api_token}/#{method}"
  end

  def call_api_method_get(method, params = {})
    JSON.parse RestClient.get(api_method_url(method), params).body
  end

  def webhook_url
    telegram_bot_updates_url(
      format:   'json',
      protocol: 'https',
      host:     Rails.application.config.site_domain,
      secret:   context.telegram_bot.secret,
    )
  end
end
