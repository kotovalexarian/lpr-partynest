# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembershipPool do
  subject { create :membership_pool }

  it { is_expected.to validate_presence_of :name }
end
