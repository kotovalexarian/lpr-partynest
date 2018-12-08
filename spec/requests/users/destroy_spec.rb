# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /users' do
  let(:current_account) { create :usual_account }

  def make_request
    delete '/users'
  end

  before do
    sign_in current_account.user
  end

  specify do
    expect { make_request }.not_to change(User, :count)
  end

  context 'after request' do
    before { make_request }

    specify do
      expect(response).to have_http_status :method_not_allowed
    end
  end
end
