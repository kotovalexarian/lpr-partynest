# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /passports/:id' do
  let!(:passport) { create :confirmed_passport }
  let(:current_user) { create :user }

  def make_request
    get "/passports/#{passport.id}"
  end

  before do
    sign_in current_user if current_user
    make_request
  end

  context 'when no user is authenticated' do
    let(:current_user) { nil }

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
    let!(:passport) { create :passport_with_passport_map }

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
    let!(:passport) { create :passport_with_passport_map_and_image }

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
