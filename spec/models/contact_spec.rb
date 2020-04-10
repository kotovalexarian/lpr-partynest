# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact do
  subject { create :some_contact }

  describe '#contact_list' do
    it { is_expected.to belong_to(:contact_list).required }

    it do
      is_expected.to \
        validate_presence_of(:contact_list)
        .with_message(:required)
    end
  end

  describe '#contact_network' do
    it { is_expected.to belong_to(:contact_network).required }

    it do
      is_expected.to \
        validate_presence_of(:contact_network)
        .with_message(:required)
    end
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

  describe '#contact_network_communicable?' do
    specify do
      expect(subject.contact_network_communicable?).to equal false
    end

    context 'when no network is set' do
      subject { build :some_contact, contact_network: nil }

      specify do
        expect(subject.contact_network_communicable?).to equal nil
      end
    end

    context 'for email' do
      subject { create :email_contact }

      specify do
        expect(subject.contact_network_communicable?).to equal true
      end
    end

    context 'for phone' do
      subject { create :phone_contact }

      specify do
        expect(subject.contact_network_communicable?).to equal false
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

  describe '#link' do
    context 'for email' do
      subject { create :email_contact }

      specify do
        expect(subject.link).to be_instance_of String
      end

      specify do
        expect(subject.link).to be_frozen
      end

      specify do
        expect(subject.link).to eq "mailto:#{subject.value}"
      end
    end

    context 'for phone' do
      subject { create :phone_contact }

      specify do
        expect(subject.link).to equal nil
      end
    end
  end
end
