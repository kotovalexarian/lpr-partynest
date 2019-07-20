# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /federal_subjects/:id' do
  let(:federal_subject) { create :federal_subject }

  before do
    sign_in current_account.user if current_account&.user

    get "/federal_subjects/#{federal_subject.id}"
  end

  for_account_types nil, :guest, :usual, :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end
end
