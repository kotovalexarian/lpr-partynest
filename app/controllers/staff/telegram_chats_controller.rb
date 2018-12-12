# frozen_string_literal: true

class Staff::TelegramChatsController < ApplicationController
  before_action :set_telegram_chat, except: :index

  # GET /staff/telegram_chats
  def index
    authorize %i[staff telegram_chat]

    @telegram_chats = policy_scope(
      TelegramChat,
      policy_scope_class: Staff::TelegramChatPolicy::Scope,
    )
  end

  # GET /staff/telegram_chats/:id
  def show
    authorize [:staff, @telegram_chat]
  end

private

  def set_telegram_chat
    @telegram_chat = TelegramChat.find params[:id]
  end
end
