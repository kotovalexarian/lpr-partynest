# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /federal_subjects' do
  before do
    sign_in current_account.user if current_account&.user

    create_list :federal_subject, 5

    get '/federal_subjects'
  end

  for_account_types nil, :usual, :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end
end
