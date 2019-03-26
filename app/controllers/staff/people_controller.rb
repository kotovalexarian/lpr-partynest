# frozen_string_literal: true

class Staff::PeopleController < ApplicationController
  # GET /staff/people
  def index
    authorize %i[staff person]
    @people = policy_scope(
      Person,
      policy_scope_class: Staff::PersonPolicy::Scope,
    )
  end
end
