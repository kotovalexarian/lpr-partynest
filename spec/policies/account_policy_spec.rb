# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountPolicy do
  subject { described_class.new account, record }

  let!(:record) { create :personal_account }

  for_account_types nil, :guest, :usual, :superuser do
    it { is_expected.to permit_action :show }

    it { is_expected.to forbid_action :index }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action :destroy }
  end
end
