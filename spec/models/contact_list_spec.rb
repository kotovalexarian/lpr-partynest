# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactList do
  subject { create :empty_contact_list }

  describe '#account' do
    it do
      is_expected.to \
        have_one(:account)
        .dependent(:restrict_with_exception)
    end
  end

  describe '#person' do
    it do
      is_expected.to \
        have_one(:person)
        .dependent(:restrict_with_exception)
    end
  end
end
