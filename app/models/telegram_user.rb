# frozen_string_literal: true

class TelegramUser < ApplicationRecord
  validates :remote_telegram_id, presence: true
  validates :first_name, presence: true

  before_validation do
    self.last_name     = nil if last_name.blank?
    self.username      = nil if username.blank?
    self.language_code = nil if language_code.blank?
  end
end
