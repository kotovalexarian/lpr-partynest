# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConfirmPassport do
  subject { described_class.call passport: passport, account: account }

  let!(:passport) { create :passport_with_passport_map_and_image }
  let!(:account) { create :usual_account }

  specify do
    expect(subject).to be_success
  end

  specify do
    expect(subject).to have_attributes passport: passport, account: account
  end

  specify do
    expect(subject.passport_confirmation).to be_instance_of PassportConfirmation
  end

  specify do
    expect(subject.passport_confirmation).to \
      have_attributes passport: passport, account: account
  end

  specify do
    expect { subject }.to \
      change { passport.reload.passport_confirmations.count }.from(0).to(1)
  end

  specify do
    expect { subject }.not_to change { passport.reload.confirmed? }.from(false)
  end

  context 'when passport is empty' do
    let!(:passport) { create :empty_passport }

    specify do
      expect(subject).to be_failure
    end

    specify do
      expect(subject).to have_attributes(
        passport: passport,
        account: account,
        passport_confirmation: nil,
      )
    end
  end

  context 'when passport has a passport map' do
    let!(:passport) { create :passport_with_passport_map }

    specify do
      expect(subject).to be_failure
    end

    specify do
      expect(subject).to have_attributes(
        passport: passport,
        account: account,
        passport_confirmation: nil,
      )
    end
  end

  context 'when passport has an image' do
    let!(:passport) { create :passport_with_image }

    specify do
      expect(subject).to be_failure
    end

    specify do
      expect(subject).to have_attributes(
        passport: passport,
        account: account,
        passport_confirmation: nil,
      )
    end
  end

  context 'when passport has a passport map and an image' do
    let!(:passport) { create :passport_with_passport_map_and_image }

    specify do
      expect { subject }.to \
        change { passport.reload.passport_confirmations.count }.from(0).to(1)
    end

    specify do
      expect { subject }.not_to \
        change { passport.reload.confirmed? }.from(false)
    end
  end

  context 'when passport has almost enough confirmations' do
    let!(:passport) { create :passport_with_almost_enough_confirmations }

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
  end

  context 'when passport has enough confirmationsh' do
    let!(:passport) { create :passport_with_enough_confirmations }

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
  end

  context 'when passport is already confimed' do
    let!(:passport) { create :confirmed_passport }

    specify do
      expect { subject }.to \
        change { passport.reload.passport_confirmations.count }
        .from(Passport::REQUIRED_CONFIRMATIONS)
        .to(Passport::REQUIRED_CONFIRMATIONS + 1)
    end

    specify do
      expect { subject }.not_to \
        change { passport.reload.confirmed? }.from(true)
    end
  end
end
