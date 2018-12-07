# frozen_string_literal: true

class TelegramBotsController < ApplicationController
  before_action :set_telegram_bot, except: :index

  # GET /telegram_bots
  def index
    authorize :telegram_bot
    @telegram_bots = policy_scope(TelegramBot)
  end

  # GET /telegram_bots/:id
  def show
    authorize @telegram_bot
  end

private

  def set_telegram_bot
    @telegram_bot = TelegramBot.find params[:id]
  end
end
