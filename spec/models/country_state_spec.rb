# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CountryState do
  subject { create :country_state }

  it do
    is_expected.to \
      have_one(:regional_office)
      .dependent(:restrict_with_exception)
  end

  it do
    is_expected.to \
      have_many(:membership_apps)
      .dependent(:restrict_with_exception)
  end

  it { is_expected.not_to validate_presence_of :regional_office }

  it { is_expected.to validate_presence_of :english_name }
  it { is_expected.to validate_presence_of :native_name }

  it { is_expected.to validate_uniqueness_of :english_name }
  it { is_expected.to validate_uniqueness_of :native_name }
end
