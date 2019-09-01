# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/people/:person_id/comments' do
  let(:person) { create :initial_person }

  before do
    sign_in current_account.user if current_account&.user

    create_list :person_comment, rand(1..5), person: person
    create_list :person_comment, rand(1..5), person: person, account: nil

    get "/staff/people/#{person.to_param}/comments"
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
