# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactNetwork do
  subject { create :contact_network }

  describe '#codename' do
    def allow_value(*)
      super.for :codename
    end

    it { is_expected.to validate_presence_of :codename }

    it do
      is_expected.to validate_length_of(:codename).is_at_least(3).is_at_most(36)
    end

    it { is_expected.to validate_uniqueness_of(:codename).case_insensitive }

    it { is_expected.not_to allow_value nil }
    it { is_expected.not_to allow_value '' }
    it { is_expected.not_to allow_value ' ' * 3 }

    it { is_expected.to allow_value Faker::Internet.username(3..36, %w[_]) }
    it { is_expected.to allow_value 'foo_bar' }
    it { is_expected.to allow_value 'foo123' }

    it do
      is_expected.not_to \
        allow_value Faker::Internet.username(3..36, %w[_]).upcase
    end

    it { is_expected.not_to allow_value Faker::Internet.email }
    it { is_expected.not_to allow_value '_foo' }
    it { is_expected.not_to allow_value 'bar_' }
    it { is_expected.not_to allow_value '1foo' }
  end

  describe '#name' do
    def allow_value(*)
      super.for :name
    end

    it { is_expected.to allow_value nil }
    it { is_expected.to allow_value '' }
    it { is_expected.to allow_value ' ' }

    it { is_expected.to allow_value Faker::Name.name }
    it { is_expected.to allow_value Faker::Name.first_name }
    it { is_expected.to allow_value 'Foo Bar' }

    it { is_expected.to validate_length_of(:name).is_at_most(255) }

    context 'when it was set to blank value' do
      subject { build :contact_network, name: ' ' * rand(100) }

      before { subject.validate }

      specify do
        expect(subject.name).to eq nil
      end
    end

    context 'when it was set to value with leading and trailing spaces' do
      subject { create :contact_network, name: name }

      let :name do
        "#{' ' * rand(4)}#{Faker::Name.name}#{' ' * rand(4)}"
      end

      before { subject.validate }

      specify do
        expect(subject.name).to eq name.strip
      end
    end
  end
end
