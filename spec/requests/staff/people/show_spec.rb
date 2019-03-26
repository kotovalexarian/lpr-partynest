# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/people/:id' do
  let!(:person) { create :initial_person }
  let(:current_account) { create :usual_account }

  def make_request
    get "/staff/people/#{person.id}"
  end

  before do
    sign_in current_account.user if current_account&.user
    make_request
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
