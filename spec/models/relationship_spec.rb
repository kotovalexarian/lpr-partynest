# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationship do
  subject { create :supporter_relationship }

  it { is_expected.to belong_to(:person).required }
  it { is_expected.to belong_to(:regional_office).required }

  describe '#start_date' do
    it { is_expected.to validate_presence_of :start_date }

    it do
      is_expected.to \
        validate_uniqueness_of(:start_date)
        .scoped_to(:person_id)
    end
  end

  describe '#status' do
    it { is_expected.to validate_presence_of :status }
  end
end
