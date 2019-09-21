# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/relation_statuses/:codename' do
  let(:current_account) { create :usual_account }

  let!(:some_relation_status) { create :some_relation_status }

  def make_request
    get "/staff/relation_statuses/#{some_relation_status.codename}"
  end

  before do
    sign_in current_account.user if current_account&.user
    make_request
  end

  for_account_types nil, :usual do
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
