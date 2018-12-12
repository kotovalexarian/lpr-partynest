# frozen_string_literal: true

class AccountTelegramContact < ApplicationRecord
  belongs_to :account
  belongs_to :telegram_chat

  validates :telegram_chat_id, uniqueness: true
end
