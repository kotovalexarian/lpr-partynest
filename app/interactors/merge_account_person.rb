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
    context.from                     = context.account.contact_list
    context.to                       = context.person.contact_list
    context.destroyable_contact_list = context.account.contact_list
  end
end
