# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /settings/roles/:id' do
  let!(:role) { current_account.add_role :superuser }

  before do
    sign_in current_account.user if current_account&.user
  end

  def make_request
    delete "/settings/roles/#{role.id}"
  end

  for_account_types :usual, :superuser do
    specify do
      expect { make_request }.to \
        change { current_account.roles.reload.count }.by(-1)
    end

    specify do
      expect { make_request }.not_to(change { AccountRole.count })
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to redirect_to settings_roles_url
      end
    end
  end
end
