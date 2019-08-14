# frozen_string_literal: true

module PeopleHelper
  def staff_person_link_or_none(person)
    if person.nil?
      translate :none
    elsif policy([:staff, person]).show?
      link_to person.full_name, [:staff, person]
    else
      person.full_name
    end
  end

  def person_status(person)
    if person.nil? || person.current_relationship.nil?
      return translate :not_in_party, scope: %i[helpers person_status]
    end

    translate person.current_relationship.status,
              scope: %i[helpers person_status]
  end
end
