# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MergeContactLists do
  subject { described_class.call from: from, to: to }

  let(:from) { create :some_contact_list }
  let(:to)   { create :some_contact_list }

  specify do
    expect { subject }.to \
      change(from.contacts, :count)
      .from(from.contacts.count)
      .to(0)
  end

  specify do
    expect { subject }.to \
      change(to.contacts, :count)
      .from(to.contacts.count)
      .to(from.contacts.count + to.contacts.count)
  end

  specify do
    expect { subject }.to \
      change(from.contacts, :to_a)
      .from(from.contacts.to_a)
      .to([])
  end

  specify do
    expect { subject }.to \
      change(to.contacts, :to_a)
      .from(to.contacts.to_a)
      .to(to.contacts.to_a + from.contacts.to_a)
  end
end
