# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Session do
  subject { create :some_session }

  describe '#account' do
    it { is_expected.to belong_to(:account).required }

    it { is_expected.to validate_presence_of(:account).with_message(:required) }
  end

  describe '#logged_at' do
    def allow_value(*)
      super.for :logged_at
    end

    it { is_expected.to validate_presence_of :logged_at }

    it { is_expected.to allow_value Faker::Time.backward.utc }
    it { is_expected.to allow_value Faker::Time.forward.utc }
  end

  describe '#ip_address' do
    it { is_expected.to validate_presence_of :ip_address }
  end
end
