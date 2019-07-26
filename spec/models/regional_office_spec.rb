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

  describe '#current_relationships' do
    it do
      is_expected.to \
        have_many(:current_relationships)
        .class_name('Relationship')
        .inverse_of(:regional_office)
        .dependent(:restrict_with_exception)
        .order(person_id: :asc, from_date: :desc)
    end
  end

  describe '#current_supporter_relationships' do
    it do
      is_expected.to \
        have_many(:current_supporter_relationships)
        .class_name('Relationship')
        .inverse_of(:regional_office)
        .dependent(:restrict_with_exception)
        .conditions(status: :supporter)
        .order(person_id: :asc, from_date: :desc)
    end
  end

  describe '#current_member_relationships' do
    it do
      is_expected.to \
        have_many(:current_member_relationships)
        .class_name('Relationship')
        .inverse_of(:regional_office)
        .dependent(:restrict_with_exception)
        .conditions(status: :member)
        .order(person_id: :asc, from_date: :desc)
    end
  end

  describe '#current_regional_manager_relationships' do
    it do
      is_expected.to \
        have_many(:current_regional_manager_relationships)
        .class_name('Relationship')
        .inverse_of(:regional_office)
        .dependent(:restrict_with_exception)
        .conditions(status: :member, role: :regional_manager)
        .order(person_id: :asc, from_date: :desc)
    end
  end

  describe '#current_regional_supervisor_relationships' do
    it do
      is_expected.to \
        have_many(:current_regional_supervisor_relationships)
        .class_name('Relationship')
        .inverse_of(:regional_office)
        .dependent(:restrict_with_exception)
        .conditions(status: :member, role: :regional_supervisor)
        .order(person_id: :asc, from_date: :desc)
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
        .dependent(:restrict_with_exception)
    end
  end

  describe '#current_people' do
    it do
      is_expected.to \
        have_many(:current_people)
        .class_name('Person')
        .inverse_of(:current_regional_office)
        .through(:current_relationships)
        .source(:person)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#current_supporter_people' do
    it do
      is_expected.to \
        have_many(:current_supporter_people)
        .class_name('Person')
        .inverse_of(:current_regional_office)
        .through(:current_supporter_relationships)
        .source(:person)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#current_member_people' do
    it do
      is_expected.to \
        have_many(:current_member_people)
        .class_name('Person')
        .inverse_of(:current_regional_office)
        .through(:current_member_relationships)
        .source(:person)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#current_regional_manager_people' do
    it do
      is_expected.to \
        have_many(:current_regional_manager_people)
        .class_name('Person')
        .inverse_of(:current_regional_office)
        .through(:current_regional_manager_relationships)
        .source(:person)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#current_regional_supervisor_people' do
    it do
      is_expected.to \
        have_many(:current_regional_supervisor_people)
        .class_name('Person')
        .inverse_of(:current_regional_office)
        .through(:current_regional_supervisor_relationships)
        .source(:person)
        .dependent(:restrict_with_exception)
    end
  end
end
