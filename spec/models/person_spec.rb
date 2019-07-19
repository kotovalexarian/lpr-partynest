# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person do
  subject { create :member_person }

  it_behaves_like 'nameable'

  it { is_expected.to belong_to(:regional_office).optional }

  xit { is_expected.to belong_to(:contacts_list).required }

  it { is_expected.to have_one(:account).dependent(:restrict_with_exception) }

  it do
    is_expected.to \
      have_many(:relationships)
      .inverse_of(:person)
      .dependent(:restrict_with_exception)
      .order(number: :asc)
  end

  it do
    is_expected.to \
      have_one(:current_relationship)
      .class_name('Relationship')
      .inverse_of(:person)
      .order(number: :desc)
  end

  it do
    is_expected.to \
      have_many(:person_comments)
      .dependent(:restrict_with_exception)
  end

  it do
    is_expected.to \
      have_many(:passports)
      .dependent(:restrict_with_exception)
  end

  it { is_expected.not_to validate_presence_of :regional_office }

  describe '#relationships' do
    let! :relationship_2 do
      create :supporter_relationship, person: subject, number: 2
    end

    let! :relationship_3 do
      create :supporter_relationship, person: subject, number: 3
    end

    let! :relationship_1 do
      create :supporter_relationship, person: subject, number: 1
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
    let! :relationship_2 do
      create :supporter_relationship, person: subject, number: 2
    end

    let! :relationship_3 do
      create :supporter_relationship, person: subject, number: 3
    end

    let! :relationship_1 do
      create :supporter_relationship, person: subject, number: 1
    end

    specify do
      expect(subject.current_relationship).to eq relationship_3
    end
  end
end
