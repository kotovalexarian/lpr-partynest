# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject { create :user }

  it do
    is_expected.to \
      have_many(:passport_confirmations)
      .dependent(:restrict_with_exception)
  end
end
