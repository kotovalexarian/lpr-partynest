# frozen_string_literal: true

class Staffs::People::PassportsController < ApplicationController
  before_action :set_person
  before_action :set_passport, only: :show

  # GET /staff/people/:person_id/passports
  def index
    authorize [:staff, @person, :passport]

    @passports = policy_scope(
      @person.passports,
      policy_scope_class: Staff::Person::PassportPolicy::Scope,
    )
  end

  # GET /staff/people/:person_id/passports/:id
  def show
    authorize [:staff, @person, @passport]
  end

private

  def set_person
    @person = Person.find params[:person_id]
  end

  def set_passport
    @passport = @person.passports.find params[:id]
  end
end
