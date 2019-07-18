# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Passport do
  subject { create :empty_passport }

  it_behaves_like 'nameable'

  it { is_expected.to belong_to(:person).optional }

  it { is_expected.to validate_presence_of :series }
  it { is_expected.to validate_presence_of :number }
  it { is_expected.to validate_presence_of :issued_by }
  it { is_expected.to validate_presence_of :unit_code }
  it { is_expected.to validate_presence_of :date_of_issue }
end
