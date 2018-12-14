# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /application' do
  let! :membership_app do
    create :membership_app, account: owner
  end

  let(:owner) { create :usual_account }

  before do
    sign_in current_account&.user if current_account&.user
    get '/application'
  end

  context 'when owner is authenticated' do
    let(:current_account) { owner }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  for_account_types nil, :guest, :usual, :superuser do
    specify do
      expect(response).to redirect_to join_url
    end
  end
end
