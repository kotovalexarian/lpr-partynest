# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /membership_apps/:id' do
  let :membership_app do
    create :membership_app, account: owner
  end

  let(:owner) { create :usual_account }

  before do
    sign_in current_account&.user if current_account&.user
    get "/membership_apps/#{membership_app.id}"
  end

  context 'when owner is authenticated' do
    let(:current_account) { owner }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when no account is authenticated' do
    let(:current_account) { nil }

    specify do
      expect(response).to have_http_status :unauthorized
    end
  end

  context 'when guest account is authenticated' do
    let(:current_account) { create :guest_account }

    specify do
      expect(response).to have_http_status :unauthorized
    end
  end

  context 'when usual account is authenticated' do
    let(:current_account) { create :usual_account }

    specify do
      expect(response).to have_http_status :unauthorized
    end
  end

  context 'when superuser account is authenticated' do
    let(:current_account) { create :superuser_account }

    specify do
      expect(response).to have_http_status :unauthorized
    end
  end
end
