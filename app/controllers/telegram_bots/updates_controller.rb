# frozen_string_literal: true

class TelegramBots::UpdatesController < ApplicationController
  before_action :set_telegram_bot
  before_action :verify_telegram_bot_secret

  skip_after_action :verify_authorized

  # POST /telegram_bots/:telegram_bot_id/updates
  def create
    logger.info params.inspect

    render status: :no_content, json: {}
  end

private

  def set_telegram_bot
    @telegram_bot = TelegramBot.find params[:telegram_bot_id]
  end

  def verify_telegram_bot_secret
    return if params[:secret] == @telegram_bot.secret

    raise NotAuthorizedError.new query:  "#{action_name}?",
                                 record: @telegram_bot
  end
end
