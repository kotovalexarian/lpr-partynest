# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Passport do
  subject { create :empty_passport }

  it_behaves_like 'nameable'

  describe '#person' do
    it { is_expected.to belong_to(:person).optional }
  end

  describe '#series' do
    it { is_expected.to validate_presence_of :series }
  end

  describe '#number' do
    it { is_expected.to validate_presence_of :number }
  end

  describe '#issued_by' do
    it { is_expected.to validate_presence_of :issued_by }
  end

  describe '#unit_code' do
    it { is_expected.to validate_presence_of :unit_code }
  end

  describe '#date_of_issue' do
    it { is_expected.to validate_presence_of :date_of_issue }
  end
end
