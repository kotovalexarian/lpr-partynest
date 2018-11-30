# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /passports/:passport_id/passport_confirmations' do
  let!(:passport) { create :passport }

  def make_request
    post "/passports/#{passport.id}/passport_confirmations"
  end

  context 'when no user is authenticated' do
    specify do
      expect { make_request }.not_to change(PassportConfirmation, :count)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  context 'when user is authorized' do
    let(:current_user) { create :user }

    before do
      sign_in current_user
    end

    specify do
      expect { make_request }.to \
        change(PassportConfirmation, :count).from(0).to(1)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to redirect_to passport
      end

      specify do
        expect(PassportConfirmation.last).to have_attributes(
          passport: passport,
          user:     current_user,
        )
      end
    end
  end
end
