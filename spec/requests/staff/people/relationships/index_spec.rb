# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/people/:person_id/relationships' do
  let(:person) { create :initial_person }

  before do
    sign_in current_account.user if current_account&.user

    create :supporter_relationship, person: person
    create :member_relationship,    person: person
    create :excluded_relationship,  person: person

    get "/staff/people/#{person.to_param}/relationships"
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
