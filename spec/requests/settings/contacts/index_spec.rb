# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /settings/contacts' do
  before do
    sign_in current_account.user if current_account&.user

    if current_account
      create_list :some_contact, rand(1..3),
                  contact_list: current_account.contact_list
    end

    get '/settings/contacts'
  end

  for_account_types nil do
    specify do
      expect(response).to have_http_status :forbidden
    end
  end

  for_account_types :usual, :personal, :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end
end
