# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Passport do
  subject { create :empty_passport }

  it do
    is_expected.to \
      have_one(:passport_map)
      .dependent(:restrict_with_exception)
  end

  it do
    is_expected.to \
      have_many(:passport_confirmations)
      .dependent(:restrict_with_exception)
  end

  pending '#image'
  pending '#enough_confirmations?'

  describe '#confirmed' do
    def allow_value(*)
      super.for :confirmed
    end

    context 'when passport is empty' do
      subject { create :empty_passport }

      it { is_expected.to allow_value false }
      it { is_expected.not_to allow_value true }
    end

    context 'when passport has passport map' do
      subject { create :passport_with_passport_map }

      it { is_expected.to allow_value false }
      it { is_expected.not_to allow_value true }
    end

    context 'when passport has image' do
      subject { create :passport_with_image }

      it { is_expected.to allow_value false }
      it { is_expected.not_to allow_value true }
    end

    context 'when passport has passport map and image' do
      subject { create :passport_with_passport_map_and_image }

      it { is_expected.to allow_value false }
      it { is_expected.not_to allow_value true }
    end

    context 'when passport has almost enough confirmations' do
      subject { create :passport_with_almost_enough_confirmations }

      it { is_expected.to allow_value false }
      it { is_expected.not_to allow_value true }
    end

    context 'when passport has enough confirmations' do
      subject { create :passport_with_enough_confirmations }

      it { is_expected.to allow_value false }
      it { is_expected.to allow_value true }
    end

    context 'when passport is confirmed' do
      subject { create :confirmed_passport }

      it { is_expected.to allow_value false }
      it { is_expected.to allow_value true }
    end
  end
end
