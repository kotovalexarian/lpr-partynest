# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactNetwork do
  subject { create :contact_network }

  describe '#to_param' do
    specify do
      expect(subject.to_param).to eq subject.codename
    end
  end

  describe '#contacts' do
    it do
      is_expected.to have_many(:contacts).dependent(:restrict_with_exception)
    end
  end

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

    it { is_expected.to validate_presence_of :name }

    it do
      is_expected.to validate_length_of(:name).is_at_least(1).is_at_most(255)
    end

    it { is_expected.not_to allow_value nil }
    it { is_expected.not_to allow_value '' }
    it { is_expected.not_to allow_value ' ' }

    it { is_expected.to allow_value Faker::Name.name }
    it { is_expected.to allow_value Faker::Name.first_name }
    it { is_expected.to allow_value 'Foo Bar' }

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
    it { is_expected.not_to allow_value "\tFoo" }
    it { is_expected.not_to allow_value "Foo\t" }
    it { is_expected.not_to allow_value "\nFoo" }
    it { is_expected.not_to allow_value "Foo\n" }
  end

  describe '#communicable?' do
    specify do
      expect(subject.communicable?).to equal false
    end

    context 'for email' do
      subject { create :email_contact_network }

      specify do
        expect(subject.communicable?).to equal true
      end
    end

    context 'for phone' do
      subject { create :phone_contact_network }

      specify do
        expect(subject.communicable?).to equal false
      end
    end
  end
end
