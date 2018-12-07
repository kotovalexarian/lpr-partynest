# frozen_string_literal: true

class TelegramBots::UpdatesController < ApplicationController
  before_action :set_telegram_bot
  before_action :verify_telegram_bot_secret

  skip_after_action :verify_authorized

  # POST /telegram_bots/:telegram_bot_id/updates
  def create
    handle_chat params.dig(:message, :chat)

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

  def handle_chat(chat)
    return if chat.blank?

    telegram_chat = TelegramChat.where(remote_id: chat[:id]).first_or_initialize

    telegram_chat.chat_type  = chat[:type]
    telegram_chat.title      = chat[:title]
    telegram_chat.username   = chat[:username]
    telegram_chat.first_name = chat[:first_name]
    telegram_chat.last_name  = chat[:last_name]

    telegram_chat.save!
  end
end
