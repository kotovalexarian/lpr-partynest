# frozen_string_literal: true

class SendTelegramMessage
  include Interactor

  BASE_URL = 'https://api.telegram.org'

  def url
    @url ||= [
      BASE_URL,
      '/bot',
      Rails.application.credentials.telegram_bot_api_token,
      '/sendMessage',
    ].join.freeze
  end

  def call
    RestClient.post(
      url,
      chat_id: context.chat_id,
      text: context.text,
    )
  rescue RuntimeError => e
    context.fail! error: e
  end
end
