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

    context 'for excluded relationship' do
      subject { create :excluded_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value described_class.roles.keys.sample }
    end

    context 'for member relationship' do
      subject { create :member_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.to allow_value described_class.roles.keys.sample }
    end
  end

  describe '#federal_secretary_flag' do
    def allow_value(*)
      super.for :federal_secretary_flag
    end

    context 'for supporter relationship' do
      subject { create :supporter_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value :federal_secretary }
    end

    context 'for excluded relationship' do
      subject { create :excluded_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value :federal_secretary }
    end

    context 'for member relationship' do
      subject { create :member_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value :federal_secretary }
    end

    context 'for federal manager relationship' do
      subject { create :federal_manager_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.to allow_value :federal_secretary }

      context 'when federal secretary already exists' do
        subject { create :federal_secretary_relationship }

        it do
          is_expected.to \
            validate_uniqueness_of(:federal_secretary_flag)
            .allow_nil
            .ignoring_case_sensitivity
        end
      end
    end

    context 'for federal supervisor relationship' do
      subject { create :federal_supervisor_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value :federal_secretary }
    end

    context 'for regional manager relationship' do
      subject { create :regional_manager_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value :federal_secretary }
    end

    context 'for regional supervisor relationship' do
      subject { create :regional_supervisor_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value :federal_secretary }
    end
  end

  describe '#regional_secretary_flag' do
    def allow_value(*)
      super.for :regional_secretary_flag
    end

    context 'for supporter relationship' do
      subject { create :supporter_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value :regional_secretary }
    end

    context 'for excluded relationship' do
      subject { create :excluded_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value :regional_secretary }
    end

    context 'for member relationship' do
      subject { create :member_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value :regional_secretary }
    end

    context 'for federal manager relationship' do
      subject { create :federal_manager_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value :regional_secretary }
    end

    context 'for federal supervisor relationship' do
      subject { create :federal_supervisor_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value :regional_secretary }
    end

    context 'for regional manager relationship' do
      subject { create :regional_manager_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.to allow_value :regional_secretary }

      context 'when regional secretary already exists' do
        subject { create :regional_secretary_relationship }

        it do
          is_expected.to \
            validate_uniqueness_of(:regional_secretary_flag)
            .allow_nil
            .ignoring_case_sensitivity
            .scoped_to(:regional_office_id)
        end
      end
    end

    context 'for regional supervisor relationship' do
      subject { create :regional_supervisor_relationship }

      it { is_expected.to allow_value nil }
      it { is_expected.not_to allow_value :regional_secretary }
    end
  end

  describe '.supporters' do
    let!(:relationship1) { create :supporter_relationship }
    let!(:relationship2) { create :member_relationship }
    let!(:relationship3) { create :excluded_relationship }
    let!(:relationship3) { create :excluded_relationship }
    let!(:relationship4) { create :federal_manager_relationship }
    let!(:relationship5) { create :federal_supervisor_relationship }
    let!(:relationship6) { create :regional_manager_relationship }
    let!(:relationship7) { create :regional_supervisor_relationship }
    let!(:relationship8) { create :supporter_relationship }

    specify do
      expect(described_class.supporters).to \
        eq [relationship1, relationship8]
    end
  end

  describe '.excluded' do
    let!(:relationship1) { create :supporter_relationship }
    let!(:relationship2) { create :member_relationship }
    let!(:relationship3) { create :excluded_relationship }
    let!(:relationship4) { create :excluded_relationship }
    let!(:relationship5) { create :federal_manager_relationship }
    let!(:relationship6) { create :federal_supervisor_relationship }
    let!(:relationship7) { create :regional_manager_relationship }
    let!(:relationship8) { create :regional_supervisor_relationship }
    let!(:relationship9) { create :excluded_relationship }

    specify do
      expect(described_class.excluded).to \
        eq [relationship3, relationship4, relationship9]
    end
  end

  describe '.members' do
    let!(:relationship1) { create :supporter_relationship }
    let!(:relationship2) { create :member_relationship }
    let!(:relationship3) { create :excluded_relationship }
    let!(:relationship4) { create :excluded_relationship }
    let!(:relationship5) { create :federal_manager_relationship }
    let!(:relationship6) { create :federal_supervisor_relationship }
    let!(:relationship7) { create :regional_manager_relationship }
    let!(:relationship8) { create :regional_supervisor_relationship }
    let!(:relationship9) { create :member_relationship }

    specify do
      expect(described_class.members).to eq [
        relationship2,
        relationship5,
        relationship6,
        relationship7,
        relationship8,
        relationship9,
      ]
    end
  end

  describe '.federal_managers' do
    let!(:relationship1) { create :supporter_relationship }
    let!(:relationship2) { create :member_relationship }
    let!(:relationship3) { create :excluded_relationship }
    let!(:relationship3) { create :excluded_relationship }
    let!(:relationship4) { create :federal_manager_relationship }
    let!(:relationship5) { create :federal_supervisor_relationship }
    let!(:relationship6) { create :regional_manager_relationship }
    let!(:relationship7) { create :regional_supervisor_relationship }
    let!(:relationship8) { create :federal_manager_relationship }

    specify do
      expect(described_class.federal_managers).to \
        eq [relationship4, relationship8]
    end
  end

  describe '.federal_supervisors' do
    let!(:relationship1) { create :supporter_relationship }
    let!(:relationship2) { create :member_relationship }
    let!(:relationship3) { create :excluded_relationship }
    let!(:relationship3) { create :excluded_relationship }
    let!(:relationship4) { create :federal_manager_relationship }
    let!(:relationship5) { create :federal_supervisor_relationship }
    let!(:relationship6) { create :regional_manager_relationship }
    let!(:relationship7) { create :regional_supervisor_relationship }
    let!(:relationship8) { create :federal_supervisor_relationship }

    specify do
      expect(described_class.federal_supervisors).to \
        eq [relationship5, relationship8]
    end
  end

  describe '.federal_secretaries' do
    let!(:relationship1) { create :supporter_relationship }
    let!(:relationship2) { create :member_relationship }
    let!(:relationship3) { create :excluded_relationship }
    let!(:relationship3) { create :excluded_relationship }
    let!(:relationship4) { create :federal_manager_relationship }
    let!(:relationship5) { create :federal_supervisor_relationship }
    let!(:relationship6) { create :regional_manager_relationship }
    let!(:relationship7) { create :regional_supervisor_relationship }
    let!(:relationship8) { create :federal_secretary_relationship }
    let!(:relationship9) { create :federal_manager_relationship }

    specify do
      expect(described_class.federal_secretaries).to eq [relationship8]
    end
  end

  describe '.regional_managers' do
    let!(:relationship1) { create :supporter_relationship }
    let!(:relationship2) { create :member_relationship }
    let!(:relationship3) { create :excluded_relationship }
    let!(:relationship3) { create :excluded_relationship }
    let!(:relationship4) { create :federal_manager_relationship }
    let!(:relationship5) { create :federal_supervisor_relationship }
    let!(:relationship6) { create :regional_manager_relationship }
    let!(:relationship7) { create :regional_supervisor_relationship }
    let!(:relationship8) { create :regional_manager_relationship }

    specify do
      expect(described_class.regional_managers).to \
        eq [relationship6, relationship8]
    end
  end

  describe '.regional_supervisors' do
    let!(:relationship1) { create :supporter_relationship }
    let!(:relationship2) { create :member_relationship }
    let!(:relationship3) { create :excluded_relationship }
    let!(:relationship3) { create :excluded_relationship }
    let!(:relationship4) { create :federal_manager_relationship }
    let!(:relationship5) { create :federal_supervisor_relationship }
    let!(:relationship6) { create :regional_manager_relationship }
    let!(:relationship7) { create :regional_supervisor_relationship }
    let!(:relationship8) { create :regional_supervisor_relationship }

    specify do
      expect(described_class.regional_supervisors).to \
        eq [relationship7, relationship8]
    end
  end

  describe '.regional_secretaries' do
    let!(:relationship1) { create :supporter_relationship }
    let!(:relationship2) { create :member_relationship }
    let!(:relationship3) { create :excluded_relationship }
    let!(:relationship3) { create :excluded_relationship }
    let!(:relationship4) { create :federal_manager_relationship }
    let!(:relationship5) { create :federal_supervisor_relationship }
    let!(:relationship6) { create :regional_manager_relationship }
    let!(:relationship7) { create :regional_supervisor_relationship }
    let!(:relationship8) { create :regional_secretary_relationship }
    let!(:relationship9) { create :regional_manager_relationship }

    specify do
      expect(described_class.regional_secretaries).to eq [relationship8]
    end
  end
end
