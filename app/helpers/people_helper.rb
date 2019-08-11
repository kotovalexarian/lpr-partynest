# frozen_string_literal: true

module PeopleHelper
  def person_status(person)
    if person.nil? || person.current_relationship.nil?
      return translate :not_in_party, scope: %i[helpers person_status]
    end

    translate person.current_relationship.status,
              scope: %i[helpers person_status]
  end
end
