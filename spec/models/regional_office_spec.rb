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
        .dependent(:restrict_with_exception)
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
end
