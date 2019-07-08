# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/passports/:id' do
  let!(:passport) { create :confirmed_passport }
  let(:current_account) { create :usual_account }

  def make_request
    get "/staff/passports/#{passport.id}"
  end

  before do
    sign_in current_account.user if current_account&.user
    make_request
  end

  for_account_types nil, :guest, :usual, :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when passport is empty' do
    let!(:passport) { create :empty_passport }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when passport has a passport map' do
    let!(:passport) { create :passport_with_map }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when passport has an image' do
    let!(:passport) { create :passport_with_image }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when passport has a passport map and an image' do
    let!(:passport) { create :passport_with_map_and_image }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when passport has almost enough confirmations' do
    let!(:passport) { create :passport_with_almost_enough_confirmations }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when passport has enough confirmations' do
    let!(:passport) { create :passport_with_enough_confirmations }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when passport is confirmed' do
    let!(:passport) { create :confirmed_passport }

    specify do
      expect(response).to have_http_status :ok
    end
  end
end
