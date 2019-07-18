# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FederalSubject do
  subject { create :federal_subject }

  it do
    is_expected.to \
      have_one(:regional_office)
      .dependent(:restrict_with_exception)
  end

  it { is_expected.not_to validate_presence_of :regional_office }

  it { is_expected.to validate_presence_of :english_name }
  it { is_expected.to validate_presence_of :native_name }

  it { is_expected.to validate_uniqueness_of :english_name }
  it { is_expected.to validate_uniqueness_of :native_name }

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
end
