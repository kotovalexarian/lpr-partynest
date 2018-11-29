# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /telegram_bot_updates' do
  before do
    post '/telegram_bot_updates'
  end

  specify do
    expect(response).to have_http_status :no_content
  end
end
