# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembershipAppPolicy do
  subject { described_class.new account, record }

  let :resolved_scope do
    described_class::Scope.new(account, MembershipApp.all).resolve
  end

  let(:record) { create :membership_app, account: owner }

  let!(:owner_record) { create :membership_app, account: owner }
  let!(:other_record) { create :membership_app }

  let(:owner) { create %i[guest_account usual_account].sample }

  let(:account) { owner }

  context 'when owner is authenticated' do
    it { is_expected.to permit_action :show }
    it { is_expected.to permit_new_and_create_actions }

    it { is_expected.to forbid_actions %i[index destroy] }
    it { is_expected.to forbid_edit_and_update_actions }

    specify { expect(resolved_scope).to be_empty }
  end

  for_account_types nil, :guest, :usual, :superuser do
    it { is_expected.to permit_new_and_create_actions }

    it { is_expected.to forbid_actions %i[index show destroy] }
    it { is_expected.to forbid_edit_and_update_actions }

    specify { expect(resolved_scope).to be_empty }
  end
end
