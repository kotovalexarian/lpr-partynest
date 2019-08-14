# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MergeAccountPerson do
  subject { described_class.call account: account, person: person }

  let(:account) { create :usual_account, contact_list: old_contact_list }
  let(:person) { create :initial_person, contact_list: new_contact_list }

  let(:old_contact_list) { create :some_contact_list }
  let(:new_contact_list) { create :some_contact_list }

  specify do
    expect { subject }.to \
      change(account, :person)
      .from(nil)
      .to(person)
  end

  specify do
    expect { subject }.to \
      change(person, :account)
      .from(nil)
      .to(account)
  end

  specify do
    expect { subject }.to \
      change(account, :contact_list)
      .from(old_contact_list)
      .to(new_contact_list)
  end

  specify do
    expect { subject }.not_to \
      change(person, :contact_list)
      .from(new_contact_list)
  end

  specify do
    expect { subject }.to \
      change(old_contact_list.contacts, :count)
      .from(old_contact_list.contacts.count)
      .to(0)
  end

  specify do
    expect { subject }.to \
      change(new_contact_list.contacts, :count)
      .from(new_contact_list.contacts.count)
      .to(old_contact_list.contacts.count + new_contact_list.contacts.count)
  end

  specify do
    expect { subject }.to \
      change(old_contact_list.contacts, :to_a)
      .from(old_contact_list.contacts.to_a)
      .to([])
  end

  specify do
    expect { subject }.to \
      change(new_contact_list.contacts, :to_a)
      .from(new_contact_list.contacts.to_a)
      .to(new_contact_list.contacts.to_a + old_contact_list.contacts.to_a)
  end
end
