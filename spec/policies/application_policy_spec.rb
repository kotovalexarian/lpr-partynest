# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationPolicy do
  subject { described_class.new account, record }

  let(:record) { nil }

  for_account_types nil, :usual, :superuser do
    it do
      is_expected.to \
        forbid_actions %i[index show new create edit update destroy]
    end
  end
end
