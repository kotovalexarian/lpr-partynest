# frozen_string_literal: true

class DestroyContactList
  include Interactor

  def call
    context.old_contact_list.destroy!
  end
end
