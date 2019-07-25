# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Passport do
  subject { create :empty_passport }

  it_behaves_like 'required_nameable'

  describe '#person' do
    it { is_expected.to belong_to(:person).optional }
  end

  describe '#federal_subject' do
    it { is_expected.to belong_to(:federal_subject).optional }
  end

  describe '#series' do
    it { is_expected.to validate_presence_of :series }
  end

  describe '#number' do
    it { is_expected.to validate_presence_of :number }
  end

  describe '#issued_by' do
    it { is_expected.to validate_presence_of :issued_by }
  end

  describe '#unit_code' do
    it { is_expected.to validate_presence_of :unit_code }
  end

  describe '#date_of_issue' do
    it { is_expected.to validate_presence_of :date_of_issue }
  end

  describe '#zip_code' do
    def allow_value(*)
      super.for :zip_code
    end

    it { is_expected.not_to validate_presence_of :zip_code }

    it { is_expected.to validate_length_of(:zip_code).allow_nil }

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
    it { is_expected.not_to allow_value "\tFoo" }
    it { is_expected.not_to allow_value "Foo\t" }
    it { is_expected.not_to allow_value "\nFoo" }
    it { is_expected.not_to allow_value "Foo\n" }
  end

  describe '#town_type' do
    def allow_value(*)
      super.for :town_type
    end

    it { is_expected.not_to validate_presence_of :town_type }

    it { is_expected.to validate_length_of(:town_type).allow_nil }

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
    it { is_expected.not_to allow_value "\tFoo" }
    it { is_expected.not_to allow_value "Foo\t" }
    it { is_expected.not_to allow_value "\nFoo" }
    it { is_expected.not_to allow_value "Foo\n" }
  end

  describe '#town_name' do
    def allow_value(*)
      super.for :town_name
    end

    it { is_expected.not_to validate_presence_of :town_name }

    it { is_expected.to validate_length_of(:town_name).allow_nil }

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
    it { is_expected.not_to allow_value "\tFoo" }
    it { is_expected.not_to allow_value "Foo\t" }
    it { is_expected.not_to allow_value "\nFoo" }
    it { is_expected.not_to allow_value "Foo\n" }
  end

  describe '#settlement_type' do
    def allow_value(*)
      super.for :settlement_type
    end

    it { is_expected.not_to validate_presence_of :settlement_type }

    it { is_expected.to validate_length_of(:settlement_type).allow_nil }

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
    it { is_expected.not_to allow_value "\tFoo" }
    it { is_expected.not_to allow_value "Foo\t" }
    it { is_expected.not_to allow_value "\nFoo" }
    it { is_expected.not_to allow_value "Foo\n" }
  end

  describe '#settlement_name' do
    def allow_value(*)
      super.for :settlement_name
    end

    it { is_expected.not_to validate_presence_of :settlement_name }

    it { is_expected.to validate_length_of(:settlement_name).allow_nil }

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
    it { is_expected.not_to allow_value "\tFoo" }
    it { is_expected.not_to allow_value "Foo\t" }
    it { is_expected.not_to allow_value "\nFoo" }
    it { is_expected.not_to allow_value "Foo\n" }
  end

  describe '#district_type' do
    def allow_value(*)
      super.for :district_type
    end

    it { is_expected.not_to validate_presence_of :district_type }

    it { is_expected.to validate_length_of(:district_type).allow_nil }

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
    it { is_expected.not_to allow_value "\tFoo" }
    it { is_expected.not_to allow_value "Foo\t" }
    it { is_expected.not_to allow_value "\nFoo" }
    it { is_expected.not_to allow_value "Foo\n" }
  end

  describe '#district_name' do
    def allow_value(*)
      super.for :district_name
    end

    it { is_expected.not_to validate_presence_of :district_name }

    it { is_expected.to validate_length_of(:district_name).allow_nil }

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
    it { is_expected.not_to allow_value "\tFoo" }
    it { is_expected.not_to allow_value "Foo\t" }
    it { is_expected.not_to allow_value "\nFoo" }
    it { is_expected.not_to allow_value "Foo\n" }
  end

  describe '#street_type' do
    def allow_value(*)
      super.for :street_type
    end

    it { is_expected.not_to validate_presence_of :street_type }

    it { is_expected.to validate_length_of(:street_type).allow_nil }

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
    it { is_expected.not_to allow_value "\tFoo" }
    it { is_expected.not_to allow_value "Foo\t" }
    it { is_expected.not_to allow_value "\nFoo" }
    it { is_expected.not_to allow_value "Foo\n" }
  end

  describe '#street_name' do
    def allow_value(*)
      super.for :street_name
    end

    it { is_expected.not_to validate_presence_of :street_name }

    it { is_expected.to validate_length_of(:street_name).allow_nil }

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
    it { is_expected.not_to allow_value "\tFoo" }
    it { is_expected.not_to allow_value "Foo\t" }
    it { is_expected.not_to allow_value "\nFoo" }
    it { is_expected.not_to allow_value "Foo\n" }
  end

  describe '#residence_type' do
    def allow_value(*)
      super.for :residence_type
    end

    it { is_expected.not_to validate_presence_of :residence_type }

    it { is_expected.to validate_length_of(:residence_type).allow_nil }

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
    it { is_expected.not_to allow_value "\tFoo" }
    it { is_expected.not_to allow_value "Foo\t" }
    it { is_expected.not_to allow_value "\nFoo" }
    it { is_expected.not_to allow_value "Foo\n" }
  end

  describe '#residence_name' do
    def allow_value(*)
      super.for :residence_name
    end

    it { is_expected.not_to validate_presence_of :residence_name }

    it { is_expected.to validate_length_of(:residence_name).allow_nil }

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
    it { is_expected.not_to allow_value "\tFoo" }
    it { is_expected.not_to allow_value "Foo\t" }
    it { is_expected.not_to allow_value "\nFoo" }
    it { is_expected.not_to allow_value "Foo\n" }
  end

  describe '#building_type' do
    def allow_value(*)
      super.for :building_type
    end

    it { is_expected.not_to validate_presence_of :building_type }

    it { is_expected.to validate_length_of(:building_type).allow_nil }

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
    it { is_expected.not_to allow_value "\tFoo" }
    it { is_expected.not_to allow_value "Foo\t" }
    it { is_expected.not_to allow_value "\nFoo" }
    it { is_expected.not_to allow_value "Foo\n" }
  end

  describe '#building_name' do
    def allow_value(*)
      super.for :building_name
    end

    it { is_expected.not_to validate_presence_of :building_name }

    it { is_expected.to validate_length_of(:building_name).allow_nil }

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
    it { is_expected.not_to allow_value "\tFoo" }
    it { is_expected.not_to allow_value "Foo\t" }
    it { is_expected.not_to allow_value "\nFoo" }
    it { is_expected.not_to allow_value "Foo\n" }
  end

  describe '#apartment_type' do
    def allow_value(*)
      super.for :apartment_type
    end

    it { is_expected.not_to validate_presence_of :apartment_type }

    it { is_expected.to validate_length_of(:apartment_type).allow_nil }

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
    it { is_expected.not_to allow_value "\tFoo" }
    it { is_expected.not_to allow_value "Foo\t" }
    it { is_expected.not_to allow_value "\nFoo" }
    it { is_expected.not_to allow_value "Foo\n" }
  end

  describe '#apartment_name' do
    def allow_value(*)
      super.for :apartment_name
    end

    it { is_expected.not_to validate_presence_of :apartment_name }

    it { is_expected.to validate_length_of(:apartment_name).allow_nil }

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
    it { is_expected.not_to allow_value "\tFoo" }
    it { is_expected.not_to allow_value "Foo\t" }
    it { is_expected.not_to allow_value "\nFoo" }
    it { is_expected.not_to allow_value "Foo\n" }
  end
end
