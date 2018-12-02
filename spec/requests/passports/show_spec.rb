# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /passports/:id' do
  before do
    get "/passports/#{passport.id}"
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
