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
    @person_comment = @person.person_comments.build
  end

  # POST /staff/people/:person_id/comments
  def create
    @person_comment = @person.person_comments.build(
      permitted_attributes([:staff, :person, PersonComment])
        .merge(account: current_account),
    )

    authorize [:staff, :person, @person_comment]

    return render :index unless @person_comment.save

    redirect_to [:staff, @person, :person_comments]
  end

private

  def set_person
    @person = Person.find params[:person_id]
  end
end
