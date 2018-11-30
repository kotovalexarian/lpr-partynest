# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /passports/new' do
  before do
    get '/passports/new'
  end

  specify do
    expect(response).to have_http_status :ok
  end
end
