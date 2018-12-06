# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembershipPoolAccount do
  subject { create :membership_pool_account }

  it { is_expected.to belong_to :membership_pool }
  it { is_expected.to belong_to :account }

  it do
    is_expected.to \
      validate_presence_of(:membership_pool)
      .with_message(:required)
  end

  it do
    is_expected.to \
      validate_presence_of(:account)
      .with_message(:required)
  end

  it do
    is_expected.to \
      validate_uniqueness_of(:account_id)
      .scoped_to(:membership_pool_id)
  end
end
