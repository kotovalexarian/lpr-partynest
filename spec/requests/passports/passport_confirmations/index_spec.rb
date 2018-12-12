# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /passports/:passport_id/passport_confirmations' do
  let!(:passport) { create :passport_with_passport_map_and_image }
  let(:current_account) { create :usual_account }

  def make_request
    get "/passports/#{passport.id}/passport_confirmations"
  end

  before do
    sign_in current_account.user if current_account&.user
    make_request
  end

  context 'when no account is authenticated' do
    let(:current_account) { nil }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when guest account is authenticated' do
    let(:current_account) { create :guest_account }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when usual account is authenticated' do
    let(:current_account) { create :usual_account }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when superuser account is authenticated' do
    let(:current_account) { create :superuser_account }

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

  context 'when passport has passport map' do
    let!(:passport) { create :passport_with_passport_map }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when passport has image' do
    let!(:passport) { create :passport_with_image }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when passport has passport map and image' do
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
