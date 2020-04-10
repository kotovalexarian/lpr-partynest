# frozen_string_literal: true

class Settings::PassportPolicy < ApplicationPolicy
  def index?
    account&.person
  end

  def show?
    account&.person && record.person == account.person
  end

  def create?
    account&.person
  end

  def permitted_attributes_for_create
    %i[
      last_name first_name middle_name sex date_of_birth place_of_birth
      series number issued_by unit_code date_of_issue zip_code
      town_type town_name settlement_type settlement_name district_type
      district_name street_type street_name residence_type residence_name
      building_type building_name apartment_type apartment_name
    ].freeze
  end
end
