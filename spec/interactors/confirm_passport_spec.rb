# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConfirmPassport do
  subject { described_class.call passport: passport, user: user }

  let!(:passport) { create :passport_with_image }
  let!(:user) { create :user }

  specify do
    expect(subject).to be_success
  end

  specify do
    expect(subject).to have_attributes passport: passport, user: user
  end

  specify do
    expect(subject.passport_confirmation).to be_instance_of PassportConfirmation
  end

  specify do
    expect(subject.passport_confirmation).to \
      have_attributes passport: passport, user: user
  end

  specify do
    expect { subject }.to \
      change { passport.reload.passport_confirmations.count }.from(0).to(1)
  end

  specify do
    expect { subject }.not_to change { passport.reload.confirmed? }.from(false)
  end

  context 'when passport has no image' do
    let!(:passport) { create :passport }

    specify do
      expect(subject).to be_failure
    end

    specify do
      expect(subject).to have_attributes(
        passport:              passport,
        user:                  user,
        passport_confirmation: nil,
      )
    end
  end

  context 'when confirmations count is almost enough' do
    before do
      (Passport::REQUIRED_CONFIRMATIONS - 1).times do
        create :passport_confirmation, passport: passport
      end
    end

    specify do
      expect { subject }.to \
        change { passport.reload.passport_confirmations.count }
        .from(Passport::REQUIRED_CONFIRMATIONS - 1)
        .to(Passport::REQUIRED_CONFIRMATIONS)
    end

    specify do
      expect { subject }.to \
        change { passport.reload.confirmed? }.from(false).to(true)
    end

    context 'and passport is already confirmed' do
      let!(:passport) { create :confirmed_passport }

      specify do
        expect { subject }.not_to \
          change { passport.reload.confirmed? }.from(true)
      end
    end
  end

  context 'when confirmations count is already enough' do
    before do
      Passport::REQUIRED_CONFIRMATIONS.times do
        create :passport_confirmation, passport: passport
      end
    end

    specify do
      expect { subject }.to \
        change { passport.reload.passport_confirmations.count }
        .from(Passport::REQUIRED_CONFIRMATIONS)
        .to(Passport::REQUIRED_CONFIRMATIONS + 1)
    end

    specify do
      expect { subject }.to \
        change { passport.reload.confirmed? }.from(false).to(true)
    end

    context 'and passport is already confirmed' do
      let!(:passport) { create :confirmed_passport }

      specify do
        expect { subject }.not_to \
          change { passport.reload.confirmed? }.from(true)
      end
    end
  end
end
