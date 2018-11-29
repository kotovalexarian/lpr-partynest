# frozen_string_literal: true

class TelegramBotUpdatesController < ApplicationController
  before_action :set_telegram_bot
  before_action :verify_telegram_bot_secret

  # POST /telegram_bot_updates
  def create
    logger.info params.inspect

    handle_message params[:message] if params[:message]

    render status: :no_content, json: {}
  end

private

  def set_telegram_bot
    @telegram_bot = TelegramBot.find params[:telegram_bot_id]
  end

  def verify_telegram_bot_secret
    raise NotAuthorizedError unless params[:secret] == @telegram_bot.secret
  end

  def handle_message(message)
    chat_id = Integer message[:chat][:id]
    text    = String  message[:text]

    RestClient.post(
      "https://api.telegram.org/bot#{@telegram_bot.api_token}/sendMessage",
      chat_id: chat_id,
      text:    "Message received: #{text}",
    )
  end
end
