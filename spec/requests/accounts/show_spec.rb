# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /accounts/:username' do
  let!(:account_record) { create :personal_account }

  before do
    sign_in current_account.user if current_account&.user
    get "/accounts/#{account_record.username}"
  end

  for_account_types nil, :guest, :usual, :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end
end
