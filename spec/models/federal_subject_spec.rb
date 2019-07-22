# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FederalSubject do
  subject { create :federal_subject }

  describe '#regional_office' do
    it do
      is_expected.to \
        have_one(:regional_office)
        .dependent(:restrict_with_exception)
    end

    it { is_expected.not_to validate_presence_of :regional_office }
  end

  describe '#english_name' do
    def allow_value(*)
      super.for :english_name
    end

    it { is_expected.to validate_presence_of :english_name }
    it { is_expected.to validate_uniqueness_of :english_name }

    it do
      is_expected.to \
        validate_length_of(:english_name).is_at_least(1).is_at_most(255)
    end

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
  end

  describe '#native_name' do
    def allow_value(*)
      super.for :native_name
    end

    it { is_expected.to validate_presence_of :native_name }
    it { is_expected.to validate_uniqueness_of :native_name }

    it do
      is_expected.to \
        validate_length_of(:native_name).is_at_least(1).is_at_most(255)
    end

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
  end

  describe '#centre' do
    def allow_value(*)
      super.for :centre
    end

    it { is_expected.to validate_presence_of :centre }

    it do
      is_expected.to \
        validate_length_of(:centre).is_at_least(1).is_at_most(255)
    end

    it { is_expected.not_to allow_value ' Foo' }
    it { is_expected.not_to allow_value 'Foo ' }
  end

  describe '#number' do
    it { is_expected.to validate_presence_of :number }
    it { is_expected.to validate_uniqueness_of :number }

    it do
      is_expected.to \
        validate_numericality_of(:number)
        .only_integer
        .is_greater_than(0)
    end
  end

  describe '#timezone' do
    def allow_value(*)
      super.for :timezone
    end

    it { is_expected.to validate_presence_of :timezone }

    it { is_expected.to allow_value '00:00:00' }
    it { is_expected.to allow_value '01:00:00' }
    it { is_expected.to allow_value '-01:00:00' }
    it { is_expected.to allow_value '05:00:00' }
    it { is_expected.to allow_value '-09:00:00' }
    it { is_expected.to allow_value '12:00:00' }
    it { is_expected.to allow_value '-12:00:00' }
    it { is_expected.to allow_value '03:30:00' }
    it { is_expected.to allow_value '-11:30:00' }
    it { is_expected.to allow_value '10:45:00' }
    it { is_expected.to allow_value '-06:15:00' }

    it { is_expected.not_to allow_value '+01:00:00' }
  end

  describe '#display_name' do
    subject do
      create :federal_subject, native_name: Faker::Address.unique.state
    end

    around do |example|
      I18n.with_locale locale do
        example.run
      end
    end

    context 'when locale is "en"' do
      let(:locale) { :en }

      specify do
        expect(subject.display_name).to eq subject.english_name
      end

      specify do
        expect(subject.display_name).not_to eq subject.native_name
      end
    end

    context 'when locale is "ru"' do
      let(:locale) { :ru }

      specify do
        expect(subject.display_name).to eq subject.native_name
      end

      specify do
        expect(subject.display_name).not_to eq subject.english_name
      end
    end
  end

  describe '.order_by_display_name' do
    let! :federal_subject_1 do
      create :federal_subject, english_name: '1', native_name: '3'
    end

    let! :federal_subject_2 do
      create :federal_subject, english_name: '3', native_name: '5'
    end

    let! :federal_subject_3 do
      create :federal_subject, english_name: '4', native_name: '4'
    end

    let! :federal_subject_4 do
      create :federal_subject, english_name: '2', native_name: '1'
    end

    let! :federal_subject_5 do
      create :federal_subject, english_name: '5', native_name: '2'
    end

    around do |example|
      I18n.with_locale locale do
        example.run
      end
    end

    context 'when locale is "en"' do
      let(:locale) { :en }

      specify do
        expect(described_class.order_by_display_name).to eq [
          federal_subject_1,
          federal_subject_4,
          federal_subject_2,
          federal_subject_3,
          federal_subject_5,
        ]
      end

      specify do
        expect(described_class.order_by_display_name(:desc)).to eq [
          federal_subject_5,
          federal_subject_3,
          federal_subject_2,
          federal_subject_4,
          federal_subject_1,
        ]
      end
    end

    context 'when locale is "ru"' do
      let(:locale) { :ru }

      specify do
        expect(described_class.order_by_display_name).to eq [
          federal_subject_4,
          federal_subject_5,
          federal_subject_1,
          federal_subject_3,
          federal_subject_2,
        ]
      end

      specify do
        expect(described_class.order_by_display_name(:desc)).to eq [
          federal_subject_2,
          federal_subject_3,
          federal_subject_1,
          federal_subject_5,
          federal_subject_4,
        ]
      end
    end
  end
end
