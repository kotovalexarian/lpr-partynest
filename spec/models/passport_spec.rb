# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Passport do
  subject { create :empty_passport }

  it { is_expected.to belong_to(:person).optional }

  it do
    is_expected.to \
      have_many(:passport_maps)
      .dependent(:restrict_with_exception)
  end

  pending '#passport_map'
  pending '#image'
end
