# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountRole do
  pending '.active'
  pending '.not_deleted'
  pending '.not_expired'

  describe '#account' do
    it { is_expected.to belong_to :account }
  end

  describe '#role' do
    it { is_expected.to belong_to :role }
  end

  describe '#deleted_at' do
    def allow_value(*)
      super.for :deleted_at
    end

    it { is_expected.to allow_value nil }
    it { is_expected.to allow_value Time.zone.now }

    it { is_expected.to allow_value Faker::Time.backward.utc }
    it { is_expected.to allow_value 1.minute.ago }
    it { is_expected.to allow_value 1.hour.ago }
    it { is_expected.to allow_value 1.day.ago }

    it { is_expected.not_to allow_value Faker::Time.forward.utc + 1.minute }
    it { is_expected.not_to allow_value 1.minute.from_now }
    it { is_expected.not_to allow_value 1.hour.from_now }
    it { is_expected.not_to allow_value 1.day.from_now }
  end

  describe '#expires_at' do
    def allow_value(*)
      super.for :expires_at
    end

    it { is_expected.to allow_value nil }
    it { is_expected.to allow_value Time.zone.now }

    it { is_expected.to allow_value Faker::Time.backward.utc }
    it { is_expected.to allow_value 1.second.ago }
    it { is_expected.to allow_value 1.hour.ago }
    it { is_expected.to allow_value 1.day.ago }

    it { is_expected.to allow_value Faker::Time.forward.utc + 1.minute }
    it { is_expected.to allow_value 1.minute.from_now }
    it { is_expected.to allow_value 1.hour.from_now }
    it { is_expected.to allow_value 1.day.from_now }
  end
end
