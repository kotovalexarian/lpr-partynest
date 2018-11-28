# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembershipApplication, type: :model do
  subject { create :membership_application }

  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.not_to validate_presence_of :middle_name }
  it { is_expected.to validate_presence_of :date_of_birth }
  it { is_expected.not_to validate_presence_of :occupation }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :phone_number }
  it { is_expected.not_to validate_presence_of :telegram_username }
  it { is_expected.not_to validate_presence_of :comment }
end
