# frozen_string_literal: true

class DestroyContactList
  include Interactor

  def call
    context.destroyable_contact_list.destroy!
  end
end
