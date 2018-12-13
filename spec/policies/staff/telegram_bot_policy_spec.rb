# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Staff::TelegramBotPolicy do
  subject { described_class.new account, record }

  let :resolved_scope do
    described_class::Scope.new(account, TelegramBot.all).resolve
  end

  let(:record) { create :telegram_bot }

  before { create_list :telegram_bot, 3 }

  [
    nil,
    :guest_account,
    :usual_account,
  ].each do |account_type|
    context "when #{account_type || :no_account} is authenticated" do
      let(:account) { create account_type if account_type }

      it { is_expected.to forbid_actions %i[index show destroy] }
      it { is_expected.to forbid_new_and_create_actions }
      it { is_expected.to forbid_edit_and_update_actions }

      specify { expect(resolved_scope).to be_empty }
    end
  end

  context 'when superuser account is authenticated' do
    let(:account) { create :superuser_account }

    it { is_expected.to permit_actions %i[index show] }

    it { is_expected.to forbid_new_and_create_actions }
    it { is_expected.to forbid_edit_and_update_actions }
    it { is_expected.to forbid_action :destroy }

    specify { expect(resolved_scope).to eq TelegramBot.all }
  end
end
