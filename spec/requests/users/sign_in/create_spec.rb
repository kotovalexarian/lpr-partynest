# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /users/sign_in' do
  let!(:user) { create :user }

  let(:user_attributes) { { email: user.email, password: user.password } }

  def make_request
    post '/users/sign_in', params: { user: user_attributes }
  end

  specify do
    expect { make_request }.not_to change(User, :count).from(1)
  end

  context 'after request' do
    before { make_request }

    specify do
      expect(response).to redirect_to root_url
    end
  end
end
