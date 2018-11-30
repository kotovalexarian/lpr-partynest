# frozen_string_literal: true

require 'rails_helper'

RSpec.describe State do
  subject { create :state }

  it { is_expected.to validate_presence_of :name }

  it { is_expected.to validate_uniqueness_of :name }
end
