# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /telegram_bot_updates' do
  let(:telegram_bot) { create :telegram_bot }

  context 'with valid params' do
    before do
      post '/telegram_bot_updates',
           params: { telegram_bot_id: telegram_bot.id,
                     secret:          telegram_bot.secret }
    end

    specify do
      expect(response).to have_http_status :no_content
    end
  end

  context 'when no telegram bot exist' do
    before do
      post '/telegram_bot_updates',
           params: { telegram_bot_id: rand(10_000..1_000_000),
                     secret:          telegram_bot.secret }
    end

    specify do
      expect(response).to have_http_status :not_found
    end
  end

  context 'when secret is not valid' do
    before do
      post '/telegram_bot_updates',
           params: { telegram_bot_id: telegram_bot.id,
                     secret:          SecureRandom.hex }
    end

    specify do
      expect(response).to have_http_status :unauthorized
    end
  end
end
