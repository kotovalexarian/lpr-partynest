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

  describe '#relationships' do
    it do
      is_expected.to \
        have_many(:relationships)
        .inverse_of(:regional_office)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#supporter_relationships' do
    it do
      is_expected.to \
        have_many(:supporter_relationships)
        .class_name('Relationship')
        .inverse_of(:regional_office)
        .dependent(:restrict_with_exception)
        .conditions(status: :supporter)
    end
  end

  describe '#member_relationships' do
    it do
      is_expected.to \
        have_many(:member_relationships)
        .class_name('Relationship')
        .inverse_of(:regional_office)
        .dependent(:restrict_with_exception)
        .conditions(status: :member)
    end
  end

  describe '#people' do
    it do
      is_expected.to \
        have_many(:people)
        .inverse_of(:regional_office)
        .through(:relationships)
        .source(:person)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#supporter_people' do
    it do
      is_expected.to \
        have_many(:supporter_people)
        .class_name('Person')
        .inverse_of(:regional_office)
        .through(:supporter_relationships)
        .source(:person)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#member_people' do
    it do
      is_expected.to \
        have_many(:member_people)
        .class_name('Person')
        .inverse_of(:regional_office)
        .through(:member_relationships)
        .source(:person)
        .dependent(:restrict_with_exception)
    end
  end
end
