# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person do
  subject { create :person }

  it do
    is_expected.to \
      have_one(:account)
      .dependent(:restrict_with_exception)
  end

  pending "add some examples to (or delete) #{__FILE__}"
end
