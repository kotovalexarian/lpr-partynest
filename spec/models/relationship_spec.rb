# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationship do
  subject { create :supporter_relationship }

  it { is_expected.to belong_to(:person).required }
  it { is_expected.to belong_to(:regional_office).required }

  describe '#supporter_since' do
    subject { create :supporter_relationship }

    def allow_value(*)
      super.for :supporter_since
    end

    it { is_expected.to validate_presence_of :supporter_since }

    it { is_expected.to allow_value Time.zone.today }
    it { is_expected.to allow_value Time.zone.yesterday }
    it { is_expected.to allow_value rand(10_000).days.ago.to_date }

    it { is_expected.not_to allow_value Time.zone.tomorrow }
    it { is_expected.not_to allow_value 1.day.from_now.to_date }
    it { is_expected.not_to allow_value rand(10_000).days.from_now.to_date }
  end

  describe '#member_since' do
    subject { create :member_relationship }

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

    it { is_expected.not_to allow_value subject.supporter_since - 1 }
  end

  describe '#excluded_since' do
    def allow_value(*)
      super.for :excluded_since
    end

    context 'for supporter' do
      subject { create :excluded_supporter_relationship }

      it { is_expected.not_to validate_presence_of :excluded_since }

      it { is_expected.to allow_value Time.zone.today }
      it { is_expected.to allow_value Time.zone.yesterday }
      it { is_expected.to allow_value subject.supporter_since + rand(500) }

      it { is_expected.not_to allow_value Time.zone.tomorrow }
      it { is_expected.not_to allow_value 1.day.from_now.to_date }
      it { is_expected.not_to allow_value rand(10_000).days.from_now.to_date }

      it { is_expected.not_to allow_value subject.supporter_since - 1 }
    end

    context 'for member' do
      subject { create :excluded_member_relationship }

      it { is_expected.not_to validate_presence_of :excluded_since }

      it { is_expected.to allow_value Time.zone.today }
      it { is_expected.to allow_value Time.zone.yesterday }
      it { is_expected.to allow_value subject.member_since + rand(500) }

      it { is_expected.not_to allow_value Time.zone.tomorrow }
      it { is_expected.not_to allow_value 1.day.from_now.to_date }
      it { is_expected.not_to allow_value rand(10_000).days.from_now.to_date }

      it { is_expected.not_to allow_value subject.supporter_since - 1 }
      it { is_expected.not_to allow_value subject.member_since    - 1 }
    end
  end
end
