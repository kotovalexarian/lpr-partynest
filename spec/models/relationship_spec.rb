# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationship do
  subject { create :supporter_relationship }

  it { is_expected.to belong_to(:person).required }
  it { is_expected.to belong_to(:regional_office).required }

  describe '#number' do
    it { is_expected.to validate_presence_of :number }

    it { is_expected.to validate_uniqueness_of(:number).scoped_to(:person_id) }

    it do
      is_expected.to \
        validate_numericality_of(:number)
        .only_integer
        .is_greater_than_or_equal_to(0)
    end
  end

  describe '#active_since' do
    it { is_expected.to validate_presence_of :active_since }
  end
end
