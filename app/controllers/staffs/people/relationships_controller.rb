# frozen_string_literal: true

class Staffs::People::RelationshipsController < ApplicationController
  before_action :set_person

  # GET /staff/people/:person_id/relationships
  def index
    authorize [:staff, @person, :relationship]
    @relationships = policy_scope(
      @person.all_relationships.reorder(from_date: :desc),
      policy_scope_class: Staff::Person::RelationshipPolicy::Scope,
    )
  end

private

  def set_person
    @person = Person.find params[:person_id]
  end
end
