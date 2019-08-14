# frozen_string_literal: true

module RegionalOfficesHelper
  def regional_office_link_or_none(regional_office)
    if regional_office.nil?
      translate :none
    elsif policy(regional_office.federal_subject).show?
      link_to regional_office.federal_subject.display_name,
              regional_office.federal_subject
    else
      regional_office.federal_subject.display_name
    end
  end

  alias staff_regional_office_link_or_none regional_office_link_or_none
end
