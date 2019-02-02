# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/membership_apps/:id' do
  let!(:membership_app) { create :membership_app }

  before do
    sign_in current_account.user if current_account&.user
    get "/staff/membership_apps/#{membership_app.id}"
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
