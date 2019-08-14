# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MergeContactLists do
  subject do
    described_class.call old_contact_list: old_contact_list,
                         new_contact_list: new_contact_list
  end

  let(:old_contact_list) { create :some_contact_list }
  let(:new_contact_list) { create :some_contact_list }

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
