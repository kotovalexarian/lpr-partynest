# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResidentRegistration do
  subject { create :empty_resident_registration }

  it { is_expected.to belong_to(:person).optional }
end
