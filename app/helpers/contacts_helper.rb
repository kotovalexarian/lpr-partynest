# frozen_string_literal: true

module ContactsHelper
  def contact_destroy_confirmation(contact)
    value = "#{Contact.model_name.human(count: 1)} \"#{contact.value}\""

    translate :destroy_confirmation, value: value
  end
end
