# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountTelegramContact do
  it { is_expected.to belong_to :account }
  it { is_expected.to belong_to :telegram_chat }

  it do
    is_expected.to \
      validate_presence_of(:account)
      .with_message(:required)
  end

  it do
    is_expected.to \
      validate_presence_of(:telegram_chat)
      .with_message(:required)
  end
end
