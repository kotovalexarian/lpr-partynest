# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /settings/contacts' do
  let(:current_account) { create :usual_account }

  let :contact_attributes do
    attributes_for :some_contact, contact_network_id: contact_network&.id
  end

  let(:contact_network) { create :contact_network }

  def make_request
    post '/settings/contacts', params: { contact: contact_attributes }
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
      expect { make_request }.to change(Contact, :count).by(1)
    end

    specify do
      expect { make_request }.to \
        change { current_account.contact_list.contacts.count }
        .by(1)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to redirect_to settings_contacts_url
      end

      specify do
        expect(Contact.order(id: :asc).last).to \
          have_attributes(contact_attributes)
      end
    end
  end

  context 'when contact network is empty' do
    let(:contact_network) { nil }

    specify do
      expect { make_request }.not_to change(Contact, :count)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to have_http_status :ok
      end
    end
  end

  context 'when value is empty' do
    let :contact_attributes do
      attributes_for :some_contact,
                     value: nil,
                     contact_network_id: contact_network&.id
    end

    specify do
      expect { make_request }.not_to change(Contact, :count)
    end

    context 'after request' do
      before { make_request }

      specify do
        expect(response).to have_http_status :ok
      end
    end
  end
end
