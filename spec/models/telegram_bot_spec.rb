# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TelegramBot do
  subject { create :telegram_bot }

  it { is_expected.to validate_presence_of :secret }
  it { is_expected.to validate_presence_of :api_token }
end
