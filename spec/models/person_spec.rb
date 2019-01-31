# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person do
  subject { create :member_person }

  it { is_expected.to belong_to(:regional_office).optional }

  it { is_expected.to have_one(:account).dependent(:restrict_with_exception) }

  it do
    is_expected.to \
      have_one(:own_membership_app)
      .class_name('MembershipApp')
      .inverse_of(:person)
      .through(:account)
      .source(:own_membership_app)
  end

  it { is_expected.not_to validate_presence_of :regional_office }

  describe '#supporter_since' do
    def allow_value(*)
      super.for :supporter_since
    end

    it { is_expected.not_to validate_presence_of :supporter_since }

    it { is_expected.to allow_value Time.zone.today }
    it { is_expected.to allow_value Time.zone.yesterday }
    it { is_expected.to allow_value rand(10_000).days.ago.to_date }

    it { is_expected.not_to allow_value Time.zone.tomorrow }
    it { is_expected.not_to allow_value 1.day.from_now.to_date }
    it { is_expected.not_to allow_value rand(10_000).days.from_now.to_date }

    context 'for initial person' do
      subject { create :initial_person }

      it { is_expected.to allow_value nil }
      it { is_expected.to allow_value Time.zone.today }
    end

    context 'for supporter person' do
      subject { create :supporter_person }

      it { is_expected.to allow_value nil }
      it { is_expected.to allow_value Time.zone.today }
    end

    context 'for member person' do
      subject { create :member_person }

      it { is_expected.to allow_value nil }
      it { is_expected.to allow_value Time.zone.today }
    end

    context 'for excluded person' do
      subject { create :excluded_person }

      it { is_expected.to allow_value nil }
      it { is_expected.to allow_value Time.zone.today }
    end
  end

  describe '#member_since' do
    def allow_value(*)
      super.for :member_since
    end

    it { is_expected.not_to validate_presence_of :member_since }

    it { is_expected.to allow_value Time.zone.today }
    it { is_expected.to allow_value Time.zone.yesterday }
    it { is_expected.to allow_value subject.supporter_since + rand(500) }

    it { is_expected.not_to allow_value Time.zone.tomorrow }
    it { is_expected.not_to allow_value 1.day.from_now.to_date }
    it { is_expected.not_to allow_value rand(10_000).days.from_now.to_date }

    context 'for initial person' do
      subject { create :initial_person }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value Time.zone.today }
    end

    context 'for supporter person' do
      subject { create :supporter_person }

      it { is_expected.to allow_value nil }
      it { is_expected.to allow_value Time.zone.today }
    end

    context 'for member person' do
      subject { create :member_person }

      it { is_expected.to allow_value nil }
      it { is_expected.to allow_value Time.zone.today }
    end

    context 'for excluded person' do
      subject { create :excluded_person }

      it { is_expected.to allow_value nil }
      it { is_expected.to allow_value Time.zone.today }
    end
  end

  describe '#excluded_since' do
    def allow_value(*)
      super.for :excluded_since
    end

    it { is_expected.not_to validate_presence_of :excluded_since }

    it { is_expected.to allow_value Time.zone.today }
    it { is_expected.to allow_value Time.zone.yesterday }
    it { is_expected.to allow_value subject.member_since + rand(500) }

    it { is_expected.not_to allow_value Time.zone.tomorrow }
    it { is_expected.not_to allow_value 1.day.from_now.to_date }
    it { is_expected.not_to allow_value rand(10_000).days.from_now.to_date }

    context 'for initial person' do
      subject { create :initial_person }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value Time.zone.today }
    end

    context 'for supporter person' do
      subject { create :supporter_person }

      it { is_expected.to allow_value nil }
      it { is_expected.to allow_value Time.zone.today }
    end

    context 'for member person' do
      subject { create :member_person }

      it { is_expected.to allow_value nil }
      it { is_expected.to allow_value Time.zone.today }
    end

    context 'for excluded person' do
      subject { create :excluded_person }

      it { is_expected.to allow_value nil }
      it { is_expected.to allow_value Time.zone.today }
    end
  end

  describe '#party_supporter?' do
    let(:result) { subject.party_supporter? }

    context 'for initial person' do
      subject { create :initial_person }

      specify { expect(result).to eq false }
    end

    context 'for party supporter' do
      subject { create :supporter_person }

      specify { expect(result).to eq true }
    end

    context 'for party member' do
      subject { create :member_person }

      specify { expect(result).to eq true }
    end

    context 'for excluded party member' do
      subject { create :excluded_person }

      specify { expect(result).to eq false }
    end
  end

  describe '#party_member?' do
    let(:result) { subject.party_member? }

    context 'for initial person' do
      subject { create :initial_person }

      specify { expect(result).to eq false }
    end

    context 'for party supporter' do
      subject { create :supporter_person }

      specify { expect(result).to eq false }
    end

    context 'for party member' do
      subject { create :member_person }

      specify { expect(result).to eq true }
    end

    context 'for excluded party member' do
      subject { create :excluded_person }

      specify { expect(result).to eq false }
    end
  end

  describe '#excluded_from_party?' do
    let(:result) { subject.excluded_from_party? }

    context 'for initial person' do
      subject { create :initial_person }

      specify { expect(result).to eq false }
    end

    context 'for party supporter' do
      subject { create :supporter_person }

      specify { expect(result).to eq false }
    end

    context 'for party member' do
      subject { create :member_person }

      specify { expect(result).to eq false }
    end

    context 'for excluded party member' do
      subject { create :excluded_person }

      specify { expect(result).to eq true }
    end
  end
end