# frozen_string_literal: true

class TelegramBotUpdatesController < ApplicationController
  before_action :set_telegram_bot
  before_action :verify_telegram_bot_secret

  # POST /telegram_bot_updates
  def create
    logger.info params.inspect

    render status: :no_content, json: {}
  end

private

  def set_telegram_bot
    @telegram_bot = TelegramBot.find params[:telegram_bot_id]
  end

  def verify_telegram_bot_secret
    raise NotAuthorizedError unless params[:secret] == @telegram_bot.secret
  end
end
