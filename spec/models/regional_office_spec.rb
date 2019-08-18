# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegionalOffice do
  subject { create :regional_office }

  describe '#federal_subject' do
    it { is_expected.to belong_to :federal_subject }

    it do
      is_expected.to \
        validate_presence_of(:federal_subject)
        .with_message(:required)
    end

    it { is_expected.to validate_uniqueness_of :federal_subject }
  end

  describe '#all_relationships' do
    it do
      is_expected.to \
        have_many(:all_relationships)
        .class_name('Relationship')
        .inverse_of(:regional_office)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#all_people' do
    it do
      is_expected.to \
        have_many(:all_people)
        .class_name('Person')
        .inverse_of(:current_regional_office)
        .through(:all_relationships)
        .source(:person)
    end
  end
end
