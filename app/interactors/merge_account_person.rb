# frozen_string_literal: true

class MergeAccountPerson
  include Interactor::Organizer

  organize MergeContactLists, SetAccountPerson, DestroyContactList

  around do |interactor|
    ActiveRecord::Base.transaction do
      interactor.call
    end
  end

  before do
    context.old_contact_list = context.account.contact_list
    context.new_contact_list = context.person.contact_list
  end
end
