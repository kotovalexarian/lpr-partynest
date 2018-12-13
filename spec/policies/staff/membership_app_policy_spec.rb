# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Staff::MembershipAppPolicy do
  subject { described_class.new account, record }

  let :resolved_scope do
    described_class::Scope.new(account, MembershipApp.all).resolve
  end

  let!(:record) { create :membership_app, account: owner }
  let!(:other_record) { create :membership_app }

  before { create_list :membership_app, 3 }

  let(:owner) { create %i[guest_account usual_account].sample }

  context 'when owner is authenticated' do
    let(:account) { owner }

    it { is_expected.to forbid_actions %i[index show destroy] }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }

    specify { expect(resolved_scope).to be_empty }
  end

  for_account_types nil, :guest, :usual do
    it { is_expected.to forbid_actions %i[index show destroy] }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }

    specify { expect(resolved_scope).to be_empty }
  end

  for_account_types :superuser do
    it { is_expected.to permit_actions %i[index show] }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action :destroy }

    specify { expect(resolved_scope).to eq MembershipApp.all }

    specify { expect(resolved_scope).to include record }
    specify { expect(resolved_scope).to include other_record }
  end
end
