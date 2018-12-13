# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationPolicy do
  subject { described_class.new context, record }

  let :context do
    described_class::Context.new account: account, guest_account: guest_account
  end

  let(:account) { create :superuser_account }
  let(:guest_account) { create :guest_account }

  let(:record) { nil }

  it do
    is_expected.to forbid_actions %i[index show new create edit update destroy]
  end
end
