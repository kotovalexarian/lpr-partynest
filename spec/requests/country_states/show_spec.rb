# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /country_states/:id' do
  let!(:country_state) { create :country_state }

  before do
    sign_in current_account.user if current_account&.user
    get "/country_states/#{country_state.id}"
  end

  for_account_types nil, :guest, :usual, :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end
end
