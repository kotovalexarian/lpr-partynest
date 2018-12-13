# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /staff/passports/new' do
  before do
    get '/staff/passports/new'
  end

  specify do
    expect(response).to have_http_status :ok
  end
end
