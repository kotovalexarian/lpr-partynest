# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationship do
  subject { create :supporter_relationship }

  describe '#person' do
    it { is_expected.to belong_to(:person).required }
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
    context 'for supporter relationship' do
      subject { create :supporter_relationship }

      it { is_expected.to validate_absence_of :role }
    end

    context 'for excluded supporter relationship' do
      subject { create :excluded_supporter_relationship }

      it { is_expected.to validate_absence_of :role }
    end

    context 'for excluded member relationship' do
      subject { create :excluded_member_relationship }

      it { is_expected.to validate_absence_of :role }
    end

    context 'for member relationship' do
      subject { create :member_relationship }

      it { is_expected.not_to validate_absence_of :role }
      it { is_expected.not_to validate_presence_of :role }
    end
  end
end
