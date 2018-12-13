# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationPolicy do
  subject { described_class.new account, record }

  let(:account) { create :superuser_account }

  let(:record) { nil }

  it do
    is_expected.to forbid_actions %i[index show new create edit update destroy]
  end
end
