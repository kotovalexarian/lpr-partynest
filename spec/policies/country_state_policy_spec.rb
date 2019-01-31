# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CountryStatePolicy do
  subject { described_class.new current_account, record }

  let :resolved_scope do
    described_class::Scope.new(current_account, CountryState.all).resolve
  end

  let!(:record) { create :country_state }
  let!(:other_record) { create :country_state }

  before { create_list :country_state, 3 }

  for_account_types nil, :guest, :usual, :superuser do
    it { is_expected.to permit_actions %i[index show] }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action :destroy }

    specify { expect(resolved_scope).to eq CountryState.all }

    specify { expect(resolved_scope).to include record }
    specify { expect(resolved_scope).to include other_record }
  end
end
