# frozen_string_literal: true

class TelegramChat < ApplicationRecord
  CHAT_TYPES = %w[private group supergroup channel].freeze

  validates :remote_id, presence: true, uniqueness: true
  validates :chat_type, presence: true, inclusion: { in: CHAT_TYPES }
end
