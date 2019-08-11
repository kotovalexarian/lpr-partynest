# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact do
  subject { create :some_contact }

  describe '#contact_list' do
    it { is_expected.to belong_to(:contact_list) }

    it { is_expected.to validate_presence_of :contact_list }
  end

  describe '#contact_network' do
    it { is_expected.to belong_to(:contact_network) }

    it { is_expected.to validate_presence_of :contact_network }
  end

  describe '#value' do
    def allow_value(*)
      super.for :value
    end

    it { is_expected.to validate_presence_of :value }

    it { is_expected.not_to allow_value nil }
    it { is_expected.not_to allow_value '' }
    it { is_expected.not_to allow_value ' ' * rand(1..3) }

    it { is_expected.to allow_value Faker::Internet.username }

    context 'when it was set to blank string' do
      subject { build :some_contact, value: value }

      let(:value) { ' ' * rand(1..3) }

      specify do
        expect { subject.validate }.to \
          change(subject, :value).from(value).to(nil)
      end
    end
  end
end
