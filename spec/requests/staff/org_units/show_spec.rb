# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/org_units/:id' do
  let(:current_account) { create :superuser_account }

  let(:some_org_unit) { create :some_root_org_unit }

  def make_request
    get "/staff/org_units/#{some_org_unit.id}"
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

  context 'when organizational unit has parent' do
    let(:some_org_unit) { create :some_children_org_unit }

    specify do
      expect(response).to have_http_status :ok
    end
  end
end
