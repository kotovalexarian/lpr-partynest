# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /membership_applications/new' do
  before do
    get '/membership_applications/new'
  end

  specify do
    expect(response).to have_http_status :ok
  end
end
