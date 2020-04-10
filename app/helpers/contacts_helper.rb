# frozen_string_literal: true

module ContactsHelper
  def contact_public_switch_confirmation(contact)
    return if contact.show_in_public?

    translate :contact_public_switch_confirmation, value: contact.value
  end

  def contact_destroy_confirmation(contact)
    value = "#{Contact.model_name.human(count: 1)} \"#{contact.value}\""

    translate :destroy_confirmation, value: value
  end
end
