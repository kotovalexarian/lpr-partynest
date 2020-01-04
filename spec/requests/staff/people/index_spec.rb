# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/people' do
  let(:current_account) { create :superuser_account }

  let :people_count do
    [0, 1, rand(2..4), rand(5..10), rand(20..40)].sample
  end

  before do
    sign_in current_account.user if current_account&.user

    create_list :initial_person, people_count

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

  context 'when there are no people' do
    let(:people_count) { 0 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there is one person' do
    let(:people_count) { 1 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are few people' do
    let(:people_count) { rand 2..4 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are many people' do
    let(:people_count) { rand 5..10 }

    specify do
      expect(response).to have_http_status :ok
    end
  end

  context 'when there are lot of people' do
    let(:people_count) { rand 20..40 }

    specify do
      expect(response).to have_http_status :ok
    end
  end
end
