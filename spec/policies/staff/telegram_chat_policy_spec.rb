# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Staff::TelegramChatPolicy do
  subject { described_class.new account, record }

  let :resolved_scope do
    described_class::Scope.new(account, TelegramChat.all).resolve
  end

  let(:record) { create :telegram_chat }

  before { create_list :telegram_chat, 3 }

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

    specify { expect(resolved_scope).to eq TelegramChat.all }
  end
end
