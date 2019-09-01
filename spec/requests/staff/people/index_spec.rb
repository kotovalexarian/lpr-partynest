# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/people' do
  before do
    sign_in current_account.user if current_account&.user

    create :initial_person
    create :supporter_person
    create :member_person
    create :excluded_person

    get '/staff/people'
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
