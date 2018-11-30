# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /users' do
  let(:user_attributes) { attributes_for :user }

  def make_request
    post '/users', params: { user: user_attributes }
  end

  specify do
    expect { make_request }.to change(User, :count).from(0).to(1)
  end

  context 'after request' do
    before { make_request }

    specify do
      expect(request).to redirect_to root_url
    end

    specify do
      expect(User.last).to have_attributes user_attributes.merge(
        password:              nil,
        password_confirmation: nil,
      )
    end
  end
end
