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

  context 'when message "from" attribute is set' do
    def make_request
      post '/telegram_bot_updates',
           params: { telegram_bot_id: telegram_bot.id,
                     secret:          telegram_bot.secret,
                     message:         { from: telegram_user_attributes } }
    end

    let :telegram_user_attributes do
      {
        id:            remote_telegram_id,
        is_bot:        is_bot,
        first_name:    first_name,
        last_name:     last_name,
        username:      username,
        language_code: language_code,
      }
    end

    let(:remote_telegram_id) { rand 1..1_000_000 }
    let(:is_bot) { [false, true].sample }
    let(:first_name) { Faker::Name.first_name }
    let(:last_name) { Faker::Name.last_name }
    let(:username) { Faker::Internet.username }
    let(:language_code) { I18n.available_locales.sample.to_s }

    specify do
      expect { make_request }.to change(TelegramUser, :count).from(0).to(1)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(TelegramUser.last).to have_attributes(
          remote_telegram_id: remote_telegram_id,
          is_bot:             is_bot,
          first_name:         first_name,
          last_name:          last_name,
          username:           username,
          language_code:      language_code,
        )
      end
    end
  end

  context 'when message "from" attribute is set and ' \
          'Telegram user already exist' do
    let! :telegram_user do
      create :telegram_user, remote_telegram_id: remote_telegram_id
    end

    def make_request
      post '/telegram_bot_updates',
           params: { telegram_bot_id: telegram_bot.id,
                     secret:          telegram_bot.secret,
                     message:         { from: telegram_user_attributes } }
    end

    let :telegram_user_attributes do
      {
        id:            remote_telegram_id,
        is_bot:        is_bot,
        first_name:    first_name,
        last_name:     last_name,
        username:      username,
        language_code: language_code,
      }
    end

    let(:remote_telegram_id) { rand 1..1_000_000 }
    let(:is_bot) { [false, true].sample }
    let(:first_name) { Faker::Name.first_name }
    let(:last_name) { Faker::Name.last_name }
    let(:username) { Faker::Internet.username }
    let(:language_code) { I18n.available_locales.sample.to_s }

    specify do
      expect { make_request }.not_to change(TelegramUser, :count).from(1)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(TelegramUser.last).to have_attributes(
          remote_telegram_id: remote_telegram_id,
          is_bot:             is_bot,
          first_name:         first_name,
          last_name:          last_name,
          username:           username,
          language_code:      language_code,
        )
      end
    end
  end
end
