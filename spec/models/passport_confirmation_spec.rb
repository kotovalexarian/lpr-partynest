# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PassportConfirmation do
  subject { create :passport_confirmation }

  it { is_expected.to belong_to(:passport).required }
  it { is_expected.to belong_to(:user).required }

  it do
    is_expected.to validate_uniqueness_of(:user_id).scoped_to(:passport_id)
  end
end
