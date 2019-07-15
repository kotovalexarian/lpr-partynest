# frozen_string_literal: true

class Staffs::People::PersonCommentsController < ApplicationController
  before_action :set_person

  # GET /staff/people/:person_id/comments
  def index
    authorize [:staff, @person, :person_comment]
    @person_comments = policy_scope(
      @person.person_comments,
      policy_scope_class: Staff::Person::PersonCommentPolicy::Scope,
    )
  end

private

  def set_person
    @person = Person.find params[:person_id]
  end
end
