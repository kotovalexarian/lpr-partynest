# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account do
  subject { create :account }

  it do
    is_expected.to \
      have_one(:user)
      .dependent(:restrict_with_exception)
  end

  it do
    is_expected.to \
      have_many(:passport_confirmations)
      .dependent(:restrict_with_exception)
  end

  it { is_expected.not_to validate_presence_of :user }
end
