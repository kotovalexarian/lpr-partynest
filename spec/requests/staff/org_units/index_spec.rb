# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/org_units' do
  let(:current_account) { create :superuser_account }

  let :org_units_count do
    [0, 1, rand(2..4), rand(5..10), rand(20..40)].sample
  end

  before do
    sign_in current_account.user if current_account&.user

    create_list :some_root_org_unit, org_units_count

    get '/staff/org_units'
  end

  it_behaves_like 'paginal controller', :org_units_count

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
