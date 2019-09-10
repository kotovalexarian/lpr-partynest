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

  describe '#user_agent' do
    def allow_value(*)
      super.for :user_agent
    end

    it { is_expected.to validate_length_of(:user_agent).is_at_most(10_000) }

    it { is_expected.to allow_value '' }
    it { is_expected.to allow_value Faker::Internet.user_agent }

    context 'when it was set to nil' do
      subject { build :some_session, user_agent: nil }
      before { subject.validate }
      specify { expect(subject.user_agent).to eq '' }
    end

    context 'when it was set to blank' do
      subject { build :some_session, user_agent: ' ' * rand(1..3) }
      before { subject.validate }
      specify { expect(subject.user_agent).to eq '' }
    end

    context 'when it has leading spaces' do
      subject { build :some_session, user_agent: user_agent }
      let(:user_agent) { "   #{Faker::Internet.user_agent}" }
      before { subject.validate }
      specify { expect(subject.user_agent).to eq user_agent.strip }
    end
  end
end
