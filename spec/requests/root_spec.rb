# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /' do
  before do
    get '/'
  end

  specify do
    expect(response).to have_http_status :ok
  end
end
