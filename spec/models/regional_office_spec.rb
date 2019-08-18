# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegionalOffice do
  subject { create :regional_office }

  describe '#federal_subject' do
    it { is_expected.to belong_to :federal_subject }

    it do
      is_expected.to \
        validate_presence_of(:federal_subject)
        .with_message(:required)
    end

    it { is_expected.to validate_uniqueness_of :federal_subject }
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

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
    it { is_expected.not_to allow_value "\tFoo" }
    it { is_expected.not_to allow_value "Foo\t" }
    it { is_expected.not_to allow_value "\nFoo" }
    it { is_expected.not_to allow_value "Foo\n" }
  end
end
