# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembershipPool do
  subject { create :membership_pool }

  it do
    is_expected.to \
      have_many(:membership_pool_apps)
      .dependent(:restrict_with_exception)
  end

  it do
    is_expected.to \
      have_many(:membership_apps)
      .through(:membership_pool_apps)
  end

  it { is_expected.to validate_presence_of :name }
end
