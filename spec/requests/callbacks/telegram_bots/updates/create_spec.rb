# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /callbacks/telegram_bots/:telegram_bot_id/updates' do
  let(:telegram_bot) { create :telegram_bot }

  context 'with valid params' do
    before do
      post "/callbacks/telegram_bots/#{telegram_bot.id}/updates",
           params: { secret: telegram_bot.secret }
    end

    specify do
      expect(response).to have_http_status :no_content
    end
  end

  context 'when no telegram bot exist' do
    before do
      post "/callbacks/telegram_bots/#{rand(10_000..1_000_000)}/updates",
           params: { secret: telegram_bot.secret }
    end

    specify do
      expect(response).to have_http_status :not_found
    end
  end

  context 'when secret is not valid' do
    before do
      post "/callbacks/telegram_bots/#{telegram_bot.id}/updates",
           params: { secret: SecureRandom.hex }
    end

    specify do
      expect(response).to have_http_status :unauthorized
    end
  end
end
