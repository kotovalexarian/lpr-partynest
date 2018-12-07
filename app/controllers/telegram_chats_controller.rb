# frozen_string_literal: true

class TelegramChatsController < ApplicationController
  before_action :set_telegram_chat, except: :index

  # GET /telegram_chats
  def index
    authorize :telegram_chat
    @telegram_chats = policy_scope(TelegramChat)
  end

  # GET /telegram_chats/:id
  def show
    authorize @telegram_chat
  end

private

  def set_telegram_chat
    @telegram_chat = TelegramChat.find params[:id]
  end
end
