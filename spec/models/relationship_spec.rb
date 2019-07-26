# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationship do
  subject { create :supporter_relationship }

  describe '#person' do
    it do
      is_expected.to belong_to(:person).inverse_of(:all_relationships).required
    end
  end

  describe '#regional_office' do
    it do
      is_expected.to \
        belong_to(:regional_office).inverse_of(:all_relationships).required
    end
  end

  describe '#from_date' do
    it { is_expected.to validate_presence_of :from_date }

    it do
      is_expected.to \
        validate_uniqueness_of(:from_date)
        .scoped_to(:person_id)
    end
  end

  describe '#status' do
    it { is_expected.to validate_presence_of :status }
  end

  describe '#role' do
    def allow_value(*)
      super.for :role
    end

    context 'for supporter relationship' do
      subject { create :supporter_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value described_class.roles.keys.sample }
    end

    context 'for excluded supporter relationship' do
      subject { create :excluded_supporter_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value described_class.roles.keys.sample }
    end

    context 'for excluded member relationship' do
      subject { create :excluded_member_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value described_class.roles.keys.sample }
    end

    context 'for member relationship' do
      subject { create :member_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.to allow_value described_class.roles.keys.sample }
    end
  end

  describe '.federal_managers' do
    let!(:relationship1) { create :supporter_relationship }
    let!(:relationship2) { create :member_relationship }
    let!(:relationship3) { create :excluded_supporter_relationship }
    let!(:relationship3) { create :excluded_member_relationship }
    let!(:relationship4) { create :federal_manager_relationship }
    let!(:relationship5) { create :regional_manager_relationship }
    let!(:relationship6) { create :regional_supervisor_relationship }
    let!(:relationship7) { create :federal_manager_relationship }

    specify do
      expect(described_class.federal_managers).to \
        eq [relationship4, relationship7]
    end
  end
end
