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

    it do
      is_expected.to \
        validate_uniqueness_of(:value)
        .scoped_to(:contact_list_id, :contact_network_id)
    end

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

  describe '#send_security_notifications' do
    def allow_value(*)
      super.for :send_security_notifications
    end

    it do
      is_expected.to \
        validate_inclusion_of(:send_security_notifications)
        .in_array([false])
    end

    context 'for email' do
      subject { create :email_contact }

      it { is_expected.to allow_value false }
      it { is_expected.to allow_value true }
    end

    context 'for phone' do
      subject { create :phone_contact }

      it do
        is_expected.to \
          validate_inclusion_of(:send_security_notifications)
          .in_array([false])
      end
    end
  end
end
