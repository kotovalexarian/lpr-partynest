# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /' do
  def make_request
    get '/'
  end

  before do
    sign_in current_account.user if current_account&.user
    make_request
  end

  for_account_types nil, :guest, :usual, :superuser do
    specify do
      expect(response).to have_http_status :ok
    end
  end
end
