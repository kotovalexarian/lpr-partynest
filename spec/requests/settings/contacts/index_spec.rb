# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /settings/contacts' do
  let(:current_account) { create :usual_account }

  let :contacts_count do
    [0, 1, rand(2..4), rand(5..10), rand(20..100)].sample
  end

  before do
    sign_in current_account.user if current_account&.user

    if current_account
      create_list :some_contact, contacts_count,
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

  context 'when there are no contacts' do
    let(:contacts_count) { 0 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there is one contact' do
    let(:contacts_count) { 1 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are few contacts' do
    let(:contacts_count) { rand 2..4 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are many contacts' do
    let(:contacts_count) { rand 5..10 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are lot of contacts' do
    let(:contacts_count) { rand 20..100 }

    specify do
      expect(response).to have_http_status :ok
    end
  end
end
