# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /users/sign_in' do
  before do
    get '/users/sign_in'
  end

  specify do
    expect(response).to have_http_status :ok
  end
end
