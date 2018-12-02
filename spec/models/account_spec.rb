# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account do
  subject { create :account }

  it do
    is_expected.to \
      have_many(:passport_confirmations)
      .dependent(:restrict_with_exception)
  end
end
