# frozen_string_literal: true

class ImportContact
  include Interactor

  def call
    return if person_id.nil?

    person = Person.find person_id
    contact_network = ContactNetwork.find contact_network_id

    context.contact = Contact.where(id: contact_id).lock(true).first_or_create!(
      contact_list: person.contact_list,
      contact_network: contact_network,
      value: value,
    )
  end

private

  def contact_id
    context.row[0].presence
  end

  def person_id
    context.row[1].presence
  end

  def contact_network_id
    context.row[2].presence
  end

  def value
    context.row[3].presence
  end
end
