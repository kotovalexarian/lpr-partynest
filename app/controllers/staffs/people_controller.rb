# frozen_string_literal: true

class Staffs::PeopleController < ApplicationController
  before_action :set_person, except: %i[index new]

  # GET /staff/people
  def index
    authorize %i[staff person]
    @people = policy_scope(
      Person,
      policy_scope_class: Staff::PersonPolicy::Scope,
    )
  end

  # GET /staff/people/:id
  def show
    authorize [:staff, @person]
  end

  # GET /staff/people/new
  def new
    @person = Person.new
    authorize [:staff, @person]
  end

private

  def set_person
    @person = Person.find params[:id]
  end
end
