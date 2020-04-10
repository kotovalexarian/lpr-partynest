# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/accounts/:account_nickname/contacts' do
  let(:current_account) { create :superuser_account }

  let(:some_account) { create :initial_account }

  let :contacts_count do
    [0, 1, rand(2..4), rand(5..10), rand(20..40)].sample
  end

  before do
    sign_in current_account.user if current_account&.user

    create_list :some_contact, contacts_count,
                contact_list: some_account.contact_list

    get "/staff/accounts/#{some_account.nickname}/contacts"
  end

  it_behaves_like 'paginal controller', :contacts_count

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
