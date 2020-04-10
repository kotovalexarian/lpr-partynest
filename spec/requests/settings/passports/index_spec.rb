# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /settings/passports' do
  let(:current_account) { create :personal_account }

  let :passports_count do
    [0, 1, rand(2..4), rand(5..10), rand(20..100)].sample
  end

  before do
    sign_in current_account.user if current_account&.user

    if current_account&.person
      create_list :empty_passport, passports_count,
                  person: current_account.person
    end

    get '/settings/passports'
  end

  it_behaves_like 'paginal controller', :passports_count

  for_account_types nil, :usual do
    specify do
      expect(response).to have_http_status :forbidden
    end
  end

  for_account_types :personal, :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end
end
