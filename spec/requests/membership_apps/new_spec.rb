# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /join' do
  let!(:membership_app) { create :membership_app, account: owner }

  let(:owner) { create :guest_account }

  before do
    sign_in current_account.user if current_account&.user

    if current_account&.guest?
      get root_url guest_token: current_account.guest_token
    end

    get '/join'
  end

  for_account_types nil, :guest, :usual, :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when guest owner is authenticated' do
    let(:owner) { create :guest_account }
    let(:current_account) { owner }

    specify do
      expect(response).to redirect_to application_url
    end
  end

  context 'when usual owner is authenticated' do
    let(:owner) { create :usual_account }
    let(:current_account) { owner }

    specify do
      expect(response).to redirect_to application_url
    end
  end
end
