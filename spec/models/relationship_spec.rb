# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationship do
  subject { create :supporter_relationship }

  describe '#status' do
    it do
      is_expected.to belong_to(:status).class_name('RelationStatus').required
    end
  end

  describe '#person' do
    it do
      is_expected.to belong_to(:person).inverse_of(:all_relationships).required
    end
  end

  describe '#regional_office' do
    it do
      is_expected.to belong_to(:regional_office).required
    end
  end

  describe '#initiator_account' do
    it do
      is_expected.to \
        belong_to(:initiator_account)
        .class_name('Account')
        .inverse_of(false)
        .optional
    end
  end

  describe '#from_date' do
    it { is_expected.to validate_presence_of :from_date }

    it do
      is_expected.to \
        validate_uniqueness_of(:from_date)
        .scoped_to(:person_id)
    end
  end
end
