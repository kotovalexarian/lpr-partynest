# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Staff::TelegramChatPolicy do
  subject { described_class.new account, record }

  let(:record) { create :telegram_chat }

  context 'when no account is authenticated' do
    let(:account) { nil }

    it { is_expected.to forbid_actions %i[index show destroy] }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'when guest account is authenticated' do
    let(:account) { create :guest_account }

    it { is_expected.to forbid_actions %i[index show destroy] }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'when usual account is authenticated' do
    let(:account) { create :usual_account }

    it { is_expected.to forbid_actions %i[index show destroy] }
    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
  end

  context 'when superuser account is authenticated' do
    let(:account) { create :superuser_account }

    it { is_expected.to permit_actions %i[index show] }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action :destroy }
  end
end
