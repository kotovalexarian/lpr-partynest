# frozen_string_literal: true

class Staffs::People::RelationshipsController < ApplicationController
  before_action :set_person

  # GET /staff/people/:person_id/relationships
  def index
    authorize [:staff, @person, :relationship]
    skip_policy_scope
  end

private

  def set_person
    @person = Person.find params[:person_id]
  end
end
