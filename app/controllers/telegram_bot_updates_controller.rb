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

  # rubocop:disable AbcSize, CyclomaticComplexity, PerceivedComplexity
  def handle_message(message)
    handle_user message[:from] if message[:from]

    return if message[:chat].nil?

    (message[:entities] || []).each do |message_entity|
      next unless message_entity[:type] == 'bot_command' &&
                  message_entity[:offset].zero? &&
                  message_entity[:length] == message[:text].length

      handle_command message[:chat][:id], message[:text] if message[:chat]
    end
  end
  # rubocop:enable AbcSize, CyclomaticComplexity, PerceivedComplexity

  def handle_user(user)
    telegram_user =
      TelegramUser.find_or_initialize_by remote_telegram_id: user[:id]

    telegram_user.is_bot        = user[:is_bot]
    telegram_user.first_name    = user[:first_name]
    telegram_user.last_name     = user[:last_name]
    telegram_user.username      = user[:username]
    telegram_user.language_code = user[:language_code]

    telegram_user.save!
  end

  def handle_command(chat_id, command)
    RestClient.post(
      "https://api.telegram.org/bot#{@telegram_bot.api_token}/sendMessage",
      chat_id: chat_id,
      text:    "Command: #{command}",
    )
  end
end
