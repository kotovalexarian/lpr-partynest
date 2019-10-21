# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrgUnitKind do
  subject { create :some_children_org_unit_kind }

  describe '#to_param' do
    specify do
      expect(subject.to_param).to eq subject.codename
    end
  end

  describe '#parent_kind' do
    it do
      is_expected.to \
        belong_to(:parent_kind)
        .class_name('OrgUnitKind')
        .inverse_of(:children_kinds)
        .optional
    end

    it { is_expected.not_to validate_presence_of :parent_kind }
  end

  describe '#children_kinds' do
    it do
      is_expected.to \
        have_many(:children_kinds)
        .class_name('OrgUnitKind')
        .inverse_of(:parent_kind)
        .with_foreign_key(:parent_kind_id)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#instance' do
    it do
      is_expected.to \
        have_many(:instances)
        .class_name('OrgUnit')
        .inverse_of(:kind)
        .with_foreign_key(:kind_id)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#relation_statuses' do
    it do
      is_expected.to \
        have_many(:relation_statuses)
        .inverse_of(:org_unit_kind)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#codename' do
    def allow_value(*)
      super.for :codename
    end

    it { is_expected.to validate_presence_of :codename }
    it { is_expected.to validate_uniqueness_of(:codename).case_insensitive }

    it do
      is_expected.to validate_length_of(:codename).is_at_least(3).is_at_most(36)
    end

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

  describe '#short_name' do
    def allow_value(*)
      super.for :short_name
    end

    it { is_expected.to validate_presence_of :short_name }
    it { is_expected.to validate_uniqueness_of :short_name }

    it do
      is_expected.to \
        validate_length_of(:short_name)
        .is_at_least(1)
        .is_at_most(255)
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

  describe '#name' do
    def allow_value(*)
      super.for :name
    end

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of :name }

    it do
      is_expected.to \
        validate_length_of(:name)
        .is_at_least(1)
        .is_at_most(255)
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

  describe '#resource_type' do
    def allow_value(*)
      super.for :resource_type
    end

    it { is_expected.to allow_value nil }

    it { is_expected.not_to allow_value '' }
    it { is_expected.not_to allow_value ' ' * rand(1..3) }

    it { is_expected.to allow_value 'FederalSubject' }
  end
end
