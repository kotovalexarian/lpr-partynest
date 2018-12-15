# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person do
  subject { create :person }

  it { is_expected.to belong_to(:regional_office) }

  it do
    is_expected.to \
      have_one(:account)
      .dependent(:restrict_with_exception)
  end

  it { is_expected.not_to validate_presence_of :regional_office }
end
