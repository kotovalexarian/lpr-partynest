# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /country_states' do
  before do
    sign_in current_account.user if current_account&.user

    create_list :country_state, 5

    get '/country_states'
  end

  for_account_types nil, :guest, :usual, :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end
end
