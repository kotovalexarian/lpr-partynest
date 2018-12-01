# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /passports/:passport_id/passport_confirmations' do
  let!(:passport) { create :passport_with_image }

  def make_request
    post "/passports/#{passport.id}/passport_confirmations"
  end

  context 'when no user is authenticated' do
    specify do
      expect { make_request }.not_to \
        change(PassportConfirmation, :count).from(0)
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

  context 'when passport confirmation already exists' do
    let(:current_user) { create :user }

    before do
      create :passport_confirmation, passport: passport, user: current_user
      sign_in current_user
    end

    specify do
      expect { make_request }.not_to \
        change(PassportConfirmation, :count).from(1)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to redirect_to passport
      end
    end
  end

  context 'when passport confirmations count is almost enough' do
    let(:current_user) { create :user }

    before do
      (Passport::REQUIRED_CONFIRMATIONS - 1).times do
        create :passport_confirmation, passport: passport
      end

      sign_in current_user
    end

    specify do
      expect { make_request }.to \
        change(PassportConfirmation, :count)
        .from(Passport::REQUIRED_CONFIRMATIONS - 1)
        .to(Passport::REQUIRED_CONFIRMATIONS)
    end

    specify do
      expect { make_request }.to \
        change { passport.reload.confirmed? }.from(false).to(true)
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

  context 'when passport is already confirmed' do
    let!(:passport) { create :confirmed_passport }

    let(:current_user) { create :user }

    before do
      sign_in current_user
    end

    specify do
      expect { make_request }.to \
        change(PassportConfirmation, :count).from(0).to(1)
    end

    specify do
      expect { make_request }.not_to \
        change { passport.reload.confirmed? }.from(true)
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

  context 'when passport has no image' do
    let!(:passport) { create :passport_without_image }

    let(:current_user) { create :user }

    before do
      sign_in current_user
    end

    specify do
      expect { make_request }.not_to \
        change(PassportConfirmation, :count).from(0)
    end

    specify do
      expect { make_request }.not_to \
        change { passport.reload.confirmed? }.from(false)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to redirect_to passport
      end
    end
  end
end
