# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /settings/contacts/:id' do
  let :contact_list do
    current_account&.contact_list || create(:empty_contact_list)
  end

  let!(:contact) { create :some_contact, contact_list: contact_list }

  def make_request
    delete "/settings/contacts/#{contact.id}"
  end

  before do
    sign_in current_account.user if current_account&.user
  end

  for_account_types nil, :initial do
    before { make_request }

    specify do
      expect(response).to have_http_status :forbidden
    end
  end

  for_account_types :usual, :personal, :superuser do
    specify do
      expect { make_request }.to change(Contact, :count).by(-1)
    end

    specify do
      expect { make_request }.to \
        change { current_account.contact_list.contacts.count }
        .by(-1)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to redirect_to settings_contacts_url
      end
    end
  end

  context 'when contact does not belong to current account' do
    let(:contact) { create :some_contact }

    before { make_request }

    for_account_types nil, :initial, :usual, :personal, :superuser do
      specify do
        expect(response).to have_http_status :forbidden
      end
    end
  end
end
