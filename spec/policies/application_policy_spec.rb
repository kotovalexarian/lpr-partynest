# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationPolicy do
  subject { described_class.new account, record }

  let(:record) { nil }

  [
    nil,
    :guest_account,
    :usual_account,
    :superuser_account,
  ].each do |account_type|
    context "when #{account_type || :no_account} is authenticated" do
      let(:account) { create account_type if account_type }

      it do
        is_expected.to \
          forbid_actions %i[index show new create edit update destroy]
      end
    end
  end
end
