# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person do
  subject { create :initial_person }

  it_behaves_like 'nameable'

  describe '#account' do
    it { is_expected.to have_one(:account).dependent(:restrict_with_exception) }
  end

  describe '#contacts_list' do
    xit { is_expected.to belong_to(:contacts_list).required }
  end

  describe '#relationships' do
    let! :relationship_2 do
      create :supporter_relationship,
             person: subject,
             from_date: 4.days.ago
    end

    let! :relationship_3 do
      create :supporter_relationship,
             person: subject,
             from_date: 2.days.ago
    end

    let! :relationship_1 do
      create :supporter_relationship,
             person: subject,
             from_date: 6.days.ago
    end

    it do
      is_expected.to \
        have_many(:relationships)
        .inverse_of(:person)
        .dependent(:restrict_with_exception)
        .order(from_date: :asc)
    end

    specify do
      expect(subject.relationships).to eq [
        relationship_1,
        relationship_2,
        relationship_3,
      ]
    end
  end

  describe '#current_relationship' do
    it do
      is_expected.to \
        have_one(:current_relationship)
        .class_name('Relationship')
        .inverse_of(:person)
        .dependent(:restrict_with_exception)
        .order(from_date: :desc)
    end

    let! :relationship_2 do
      create :supporter_relationship,
             person: subject,
             from_date: 4.days.ago
    end

    let! :relationship_3 do
      create :supporter_relationship,
             person: subject,
             from_date: 2.days.ago
    end

    let! :relationship_1 do
      create :supporter_relationship,
             person: subject,
             from_date: 6.days.ago
    end

    specify do
      expect(subject.current_relationship).to eq relationship_3
    end
  end

  describe '#regional_office' do
    it do
      is_expected.to \
        have_one(:regional_office)
        .inverse_of(:all_people)
        .through(:current_relationship)
        .source(:regional_office)
        .dependent(:restrict_with_exception)
    end

    it { is_expected.not_to validate_presence_of :regional_office }
  end

  describe '#person_comments' do
    it do
      is_expected.to \
        have_many(:person_comments)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#passports' do
    it do
      is_expected.to \
        have_many(:passports)
        .dependent(:restrict_with_exception)
    end
  end
end
