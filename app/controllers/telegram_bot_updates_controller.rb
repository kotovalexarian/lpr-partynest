# frozen_string_literal: true

class TelegramBotUpdatesController < ApplicationController
  # POST /telegram_bot_updates
  def create
    logger.info params.inspect

    render status: :no_content, json: {}
  end
end
