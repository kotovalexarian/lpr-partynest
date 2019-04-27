# frozen_string_literal: true

class Staff::People::PassportsController < ApplicationController
  before_action :set_person

  # GET /staff/people/:person_id/passports
  def index
    authorize [:staff, @person, :passport]
    @passports = policy_scope(
      @person.passports,
      policy_scope_class: Staff::Person::PassportPolicy::Scope,
    )
  end

private

  def set_person
    @person = Person.find params[:person_id]
  end
end
