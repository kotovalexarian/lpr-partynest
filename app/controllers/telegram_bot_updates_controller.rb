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
    handle_user message[:from] if message[:from]
  end

  def handle_user(user)
    TelegramUser.create!(
      remote_telegram_id: user[:id],
      is_bot:             user[:is_bot],
      first_name:         user[:first_name],
      last_name:          user[:last_name],
      username:           user[:username],
      language_code:      user[:language_code],
    )
  end
end
