# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /passports/:id' do
  before do
    get "/passports/#{passport.id}"
  end

  context 'when passport has no image' do
    let!(:passport) { create :passport_without_image }

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

  context 'when passport is confirmed' do
    let!(:passport) { create :confirmed_passport }

    specify do
      expect(response).to have_http_status :ok
    end
  end
end
