# frozen_string_literal: true

class TelegramBot < ApplicationRecord
  validates :secret, presence: true
end
