# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RelationTransition do
  subject { create :some_relation_transition }

  describe '#from_status' do
    it do
      is_expected.to \
        belong_to(:from_status).class_name('RelationStatus').optional
    end

    it { is_expected.not_to validate_presence_of :from_status }
  end

  describe '#to_status' do
    def allow_value(*)
      super.for :to_status
    end

    it { is_expected.to belong_to(:to_status).class_name('RelationStatus') }

    it do
      is_expected.to validate_presence_of(:to_status).with_message(:required)
    end

    it { is_expected.not_to allow_value subject.from_status }
  end

  describe '#name' do
    def allow_value(*)
      super.for :name
    end

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of :name }

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
end
