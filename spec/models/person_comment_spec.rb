# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PersonComment do
  subject { create :person_comment }

  describe '#person' do
    it { is_expected.to belong_to(:person).required }
  end

  describe '#account' do
    it { is_expected.to belong_to(:account).optional }
  end

  describe '#text' do
    it { is_expected.to validate_presence_of :text }

    it do
      is_expected.to \
        validate_length_of(:text)
        .is_at_least(1)
        .is_at_most(10_000)
    end
  end
end
