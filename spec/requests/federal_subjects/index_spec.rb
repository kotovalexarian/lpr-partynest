# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /federal_subjects' do
  let(:current_account) { create :superuser_account }

  let :federal_subjects_count do
    [0, 1, rand(2..4), rand(5..10), rand(20..40)].sample
  end

  before do
    sign_in current_account.user if current_account&.user

    create_list :federal_subject, federal_subjects_count

    get '/federal_subjects'
  end

  it_behaves_like 'paginal controller', :federal_subjects_count

  for_account_types nil, :usual, :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end
end
