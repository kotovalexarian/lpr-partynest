# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactsList do
  subject { create :contacts_list }

  it do
    is_expected.to \
      have_one(:account)
      .dependent(:restrict_with_exception)
  end

  it do
    is_expected.to \
      have_one(:person)
      .dependent(:restrict_with_exception)
  end
end
