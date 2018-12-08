# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /users' do
  def make_request
    delete '/users'
  end

  before do
    sign_in current_account.user if current_account&.user
  end

  context 'when guest account is authenticated' do
    let(:current_account) { create :guest_account }

    specify do
      expect { make_request }.not_to change(User, :count)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  context 'when usual account is authenticated' do
    let(:current_account) { create :usual_account }

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

  context 'when superuser account is authenticated' do
    let(:current_account) { create :superuser_account }

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
end
