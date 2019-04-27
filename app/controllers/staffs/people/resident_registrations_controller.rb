# frozen_string_literal: true

class Staffs::People::ResidentRegistrationsController < ApplicationController
  before_action :set_person

  # GET /staff/people/:person_id/resident_registrations
  def index
    authorize [:staff, @person, :resident_registration]
    @resident_registrations = policy_scope(
      @person.resident_registrations,
      policy_scope_class: Staff::Person::ResidentRegistrationPolicy::Scope,
    )
  end

private

  def set_person
    @person = Person.find params[:person_id]
  end
end
