# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /membership_apps/new' do
  before do
    get '/membership_apps/new'
  end

  specify do
    expect(response).to have_http_status :ok
  end
end
