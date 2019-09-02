# frozen_string_literal: true

module PeopleHelper
  def staff_person_link_or_none(person)
    if person.nil?
      none
    elsif policy([:staff, person]).show?
      link_to person.full_name, [:staff, person]
    else
      person.full_name
    end
  end

  def person_account_connection_link(person)
    new_settings_person_url token: person.account_connection_token
  end
end
