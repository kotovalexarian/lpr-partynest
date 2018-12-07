# frozen_string_literal: true

class InitializeTelegramBot
  include Interactor

  def call
    url = "https://api.telegram.org/bot#{context.telegram_bot.api_token}/getMe"
    data = JSON.parse RestClient.get(url).body

    context.fail! unless data['ok'] && context.telegram_bot.update(
      username: data['result']['username'],
    )
  end
end
