# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CountryState do
  subject { create :country_state }

  it do
    is_expected.to \
      have_many(:membership_apps)
      .dependent(:restrict_with_exception)
  end

  it { is_expected.to validate_presence_of :name }

  it { is_expected.to validate_uniqueness_of :name }
end
