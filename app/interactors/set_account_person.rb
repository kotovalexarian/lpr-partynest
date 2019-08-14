# frozen_string_literal: true

class SetAccountPerson
  include Interactor

  def call
    context.account.update! person: context.person,
                            contact_list: context.new_contact_list
  end
end
