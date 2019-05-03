# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person do
  subject { create :member_person }

  it_behaves_like 'nameable'

  it { is_expected.to belong_to(:regional_office).optional }

  it { is_expected.to have_one(:account).dependent(:restrict_with_exception) }

  it do
    is_expected.to \
      have_many(:relationships)
      .inverse_of(:person)
      .dependent(:restrict_with_exception)
      .order(number: :asc)
  end

  it do
    is_expected.to \
      have_one(:current_relationship)
      .class_name('Relationship')
      .inverse_of(:person)
      .order(number: :desc)
  end

  it do
    is_expected.to \
      have_many(:passports)
      .dependent(:restrict_with_exception)
  end

  it do
    is_expected.to \
      have_many(:resident_registrations)
      .dependent(:restrict_with_exception)
  end

  it { is_expected.not_to validate_presence_of :regional_office }

  describe '#relationships' do
    let! :relationship_2 do
      create :supporter_relationship, person: subject, number: 2
    end

    let! :relationship_3 do
      create :supporter_relationship, person: subject, number: 3
    end

    let! :relationship_1 do
      create :supporter_relationship, person: subject, number: 1
    end

    specify do
      expect(subject.relationships).to eq [
        relationship_1,
        relationship_2,
        relationship_3,
      ]
    end
  end

  describe '#current_relationship' do
    let! :relationship_2 do
      create :supporter_relationship, person: subject, number: 2
    end

    let! :relationship_3 do
      create :supporter_relationship, person: subject, number: 3
    end

    let! :relationship_1 do
      create :supporter_relationship, person: subject, number: 1
    end

    specify do
      expect(subject.current_relationship).to eq relationship_3
    end
  end

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
