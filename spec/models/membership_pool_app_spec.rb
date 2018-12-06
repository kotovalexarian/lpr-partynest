# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembershipPoolApp do
  subject { create :membership_pool_app }

  it { is_expected.to belong_to :membership_pool }
  it { is_expected.to belong_to :membership_app }

  it do
    is_expected.to \
      validate_presence_of(:membership_pool)
      .with_message(:required)
  end

  it do
    is_expected.to \
      validate_presence_of(:membership_app)
      .with_message(:required)
  end

  it do
    is_expected.to \
      validate_uniqueness_of(:membership_pool_id)
      .scoped_to(:membership_app_id)
  end
end
