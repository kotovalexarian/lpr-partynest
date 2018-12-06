# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /membership_pools' do
  before do
    create :membership_pool

    get '/membership_pools'
  end

  specify do
    expect(response).to have_http_status :ok
  end
end
