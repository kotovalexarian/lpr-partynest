# frozen_string_literal: true

class TelegramBotsController < ApplicationController
  # GET /telegram_bots
  def index
    authorize :telegram_bot
    @telegram_bots = policy_scope(TelegramBot)
  end
end
