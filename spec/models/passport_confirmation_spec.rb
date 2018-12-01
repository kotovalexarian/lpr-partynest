# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PassportConfirmation do
  subject { create :passport_confirmation }

  it { is_expected.to belong_to(:passport).required }
  it { is_expected.to belong_to(:user).required }

  it do
    is_expected.to validate_uniqueness_of(:user_id).scoped_to(:passport_id)
  end

  it { is_expected.not_to allow_value(create(:passport)).for :passport }
  it { is_expected.to allow_value(create(:confirmed_passport)).for :passport }
end
