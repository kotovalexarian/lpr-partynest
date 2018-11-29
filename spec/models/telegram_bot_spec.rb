# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TelegramBot, type: :model do
  subject { create :telegram_bot }

  it { is_expected.to validate_presence_of :secret }
end
