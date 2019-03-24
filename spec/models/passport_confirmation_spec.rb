# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PassportConfirmation do
  subject { create :passport_confirmation }

  it { is_expected.to belong_to(:passport).required }
  it { is_expected.to belong_to(:account).required }

  it { is_expected.to validate_presence_of(:passport).with_message(:required) }
  it { is_expected.to validate_presence_of(:account).with_message(:required) }

  it do
    is_expected.to validate_uniqueness_of(:account).scoped_to(:passport_id)
  end

  it { is_expected.not_to allow_value(create(:empty_passport)).for :passport }

  it do
    is_expected.not_to \
      allow_value(create(:passport_with_passport_map)).for :passport
  end

  it do
    is_expected.not_to \
      allow_value(create(:passport_with_image)).for :passport
  end

  it do
    is_expected.to \
      allow_value(create(:passport_with_passport_map_and_image)).for :passport
  end

  it do
    is_expected.to \
      allow_value(create(:passport_with_almost_enough_confirmations))
      .for :passport
  end

  it do
    is_expected.to \
      allow_value(create(:passport_with_enough_confirmations)).for :passport
  end

  it { is_expected.to allow_value(create(:confirmed_passport)).for :passport }
end
