# frozen_string_literal: true

class TelegramBot < ApplicationRecord
  validates :secret, presence: true
  validates :api_token, presence: true
end
