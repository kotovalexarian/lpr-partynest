# frozen_string_literal: true

class Staffs::PeopleController < ApplicationController
  before_action :set_person, except: %i[index new create]

  # GET /staff/people
  def index
    authorize [:staff, Person]
    @people = policy_scope(
      Person,
      policy_scope_class: Staff::PersonPolicy::Scope,
    ).page(params[:page])
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

  # POST /staff/people
  def create
    @person = Person.new permitted_attributes [:staff, Person]
    @person.contact_list = ContactList.new

    authorize [:staff, @person]

    return render :new unless @person.save

    redirect_to [:staff, @person]
  end

private

  def set_person
    @person = Person.find params[:id]
  end
end
