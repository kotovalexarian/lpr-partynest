# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/org_unit_kinds/:codename' do
  let(:current_account) { create :superuser_account }

  let(:some_org_unit_kind) { create :some_root_org_unit_kind }

  def make_request
    get "/staff/org_unit_kinds/#{some_org_unit_kind.codename}"
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

  context 'when organizational unit type has parent' do
    let(:some_org_unit_kind) { create :some_children_org_unit_kind }

    specify do
      expect(response).to have_http_status :ok
    end
  end
end
