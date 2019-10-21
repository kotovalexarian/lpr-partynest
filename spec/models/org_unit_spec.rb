# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrgUnit do
  subject { create :some_children_org_unit }

  describe '#kind' do
    it do
      is_expected.to \
        belong_to(:kind)
        .class_name('OrgUnitKind')
        .inverse_of(:instances)
        .required
    end

    it { is_expected.to validate_presence_of(:kind).with_message(:required) }
  end

  describe '#parent_unit' do
    it do
      is_expected.to \
        belong_to(:parent_unit)
        .class_name('OrgUnit')
        .inverse_of(:children_units)
    end

    context 'when organizational unit type does not require parent' do
      subject { create :some_root_org_unit }

      it do
        is_expected.not_to \
          validate_presence_of(:parent_unit)
          .with_message(:required)
      end
    end

    context 'when organizational unit type requires parent' do
      subject { create :some_children_org_unit }

      it do
        is_expected.to \
          validate_presence_of(:parent_unit)
          .with_message(:required)
      end
    end
  end

  describe '#resource' do
    it { is_expected.to belong_to(:resource).optional }

    context 'when organizational unit type does not require resource' do
      subject { create :some_children_org_unit }

      it do
        is_expected.not_to \
          validate_presence_of(:resource)
          .with_message(:required)
      end
    end

    context 'when organizational unit type requires resource' do
      subject do
        create :some_children_org_unit,
               kind: org_unit_kind,
               resource: resource
      end

      let :org_unit_kind do
        create :some_children_org_unit_kind,
               resource_type: resource.class.name
      end

      let(:resource) { create :federal_subject }

      it do
        is_expected.to \
          validate_presence_of(:resource)
          .with_message(:required)
      end
    end
  end

  describe '#children_units' do
    it do
      is_expected.to \
        have_many(:children_units)
        .class_name('OrgUnit')
        .inverse_of(:parent_unit)
        .with_foreign_key(:parent_unit_id)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#all_relationships' do
    it do
      is_expected.to \
        have_many(:all_relationships)
        .class_name('Relationship')
        .inverse_of(:org_unit)
        .dependent(:restrict_with_exception)
    end
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
end
