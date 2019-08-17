# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/contact_networks' do
  before do
    sign_in current_account.user if current_account&.user

    create_list :contact_network, rand(1..5)

    get '/staff/contact_networks'
  end

  for_account_types nil, :guest, :usual do
    specify do
      expect(response).to have_http_status :forbidden
    end
  end

  for_account_types :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end
end
