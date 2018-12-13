# frozen_string_literal: true

class Staff::TelegramBotsController < ApplicationController
  before_action :set_telegram_bot, except: :index

  # GET /staff/telegram_bots
  def index
    authorize %i[staff telegram_bot]
    @telegram_bots = policy_scope(
      TelegramBot,
      policy_scope_class: Staff::TelegramBotPolicy::Scope,
    )
  end

  # GET /staff/telegram_bots/:id
  def show
    authorize [:staff, @telegram_bot]
  end

private

  def set_telegram_bot
    @telegram_bot = TelegramBot.find params[:id]
  end
end
