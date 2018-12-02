# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PassportConfirmation do
  subject { create :passport_confirmation }

  it { is_expected.to belong_to(:passport).required }
  it { is_expected.to belong_to(:account).required }

  it { is_expected.to validate_presence_of(:passport).with_message(:required) }
  it { is_expected.to validate_presence_of(:account).with_message(:required) }

  it do
    is_expected.to validate_uniqueness_of(:account_id).scoped_to(:passport_id)
  end

  it do
    is_expected.not_to \
      allow_value(create(:passport_without_image)).for :passport
  end

  it { is_expected.to allow_value(create(:confirmed_passport)).for :passport }
end
