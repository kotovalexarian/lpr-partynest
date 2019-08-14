# frozen_string_literal: true

class SetAccountPerson
  include Interactor

  def call
    old_contact_list = context.account.contact_list

    context.account.update! person: context.person,
                            contact_list: context.person.contact_list

    old_contact_list.reload
  end
end
