# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegionalOffice do
  subject { create :regional_office }

  it { is_expected.to belong_to :country_state }

  it do
    is_expected.to \
      validate_presence_of(:country_state)
      .with_message(:required)
  end

  it { is_expected.to validate_uniqueness_of :country_state_id }
end
