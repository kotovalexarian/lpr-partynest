# frozen_string_literal: true

class TelegramBot < ApplicationRecord
  USERNAME_RE = /\A[a-z_][a-z0-9_]*\z/i.freeze

  validates :secret, presence: true
  validates :api_token, presence: true

  validates :username,
            allow_nil: true,
            presence:  true,
            format:    USERNAME_RE
end
