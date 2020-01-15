# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendTelegramMessage do
  subject { described_class.call chat_id: chat_id, text: text }

  let(:chat_id) { rand 0...10_000 }
  let(:text) { Faker::Lorem.paragraph }

  let :request do
    stub_request(
      :post,
      [
        'https://api.telegram.org',
        '/bot',
        Rails.application.credentials.telegram_bot_api_token,
        '/sendMessage',
      ].join,
    ).with(
      body: {
        chat_id: chat_id,
        text: text,
      },
    )
  end

  context 'when request succeeds' do
    let!(:response) { request }

    after do
      expect(response).to have_been_made.once
    end

    specify do
      expect(subject).to be_success
    end
  end

  context 'when request fails' do
    let!(:response) { request.to_return status: [500, 'Internal Server Error'] }

    after do
      expect(response).to have_been_made.once
    end

    specify do
      expect(subject).to be_failure
    end
  end
end
