# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationship do
  subject { create :supporter_relationship }

  describe '#org_unit' do
    it do
      is_expected.to \
        belong_to(:org_unit)
        .inverse_of(:all_relationships)
        .required
    end
  end

  describe '#parent_rel' do
    it do
      is_expected.to \
        belong_to(:parent_rel)
        .class_name('Relationship')
        .inverse_of(:children_rels)
        .optional
    end
  end

  describe '#children_rels' do
    it do
      is_expected.to \
        have_many(:children_rels)
        .class_name('Relationship')
        .inverse_of(:parent_rel)
        .with_foreign_key(:parent_rel_id)
        .dependent(:restrict_with_exception)
    end
  end

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

  describe '#from_date' do
    it { is_expected.to validate_presence_of :from_date }

    it do
      is_expected.to \
        validate_uniqueness_of(:from_date)
        .scoped_to(:person_id, :org_unit_id)
    end
  end
end
